open Async
open Core
open Websocket_async

exception Invalid_Payload
exception Failure_to_Establish_Heartbeat

module Shard = struct
    type shard = {
        hb_interval: Time.Span.t Ivar.t;
        seq: int;
        session: string option;
        pipe: Frame.t Pipe.Reader.t * Frame.t Pipe.Writer.t;
        ready: unit Ivar.t;
        url: string;
        id: int * int;
        _internal: Reader.t * Writer.t;
    }

    type 'a t = {
        mutable state: 'a;
    }

    let identify_lock = Mvar.create ()
    let _ = Mvar.set identify_lock ()

    let parse (frame:[`Ok of Frame.t | `Eof]) =
        match frame with
        | `Ok s -> begin
            let open Frame.Opcode in
            match s.opcode with
            | Text -> Some (Yojson.Safe.from_string s.content)
            | _ -> None
        end
        | `Eof -> None

    let push_frame ?payload ~ev shard =
        let content = match payload with
        | None -> ""
        | Some p ->
            Yojson.Safe.to_string @@ `Assoc [
            ("op", `Int (Opcode.to_int ev));
            ("d", p);
            ]
        in
        let (_, write) = shard.pipe in
        Pipe.write write @@ Frame.create ~content ()
        >>| fun () ->
        shard

    let heartbeat shard =
        Logs.debug (fun m -> m "Heartbeating - Shard: [%d, %d] - Seq: %d" (fst shard.id) (snd shard.id) (shard.seq));
        let payload = match shard.seq with
        | 0 -> `Null
        | i -> `Int i
        in
        push_frame ~payload ~ev:HEARTBEAT shard

    let dispatch ~payload shard =
        let module J = Yojson.Safe.Util in
        let seq = J.(member "s" payload |> to_int) in
        let t = J.(member "t" payload |> to_string) in
        let data = J.member "d" payload in
        let session = if t = "READY" then begin
            Ivar.fill_if_empty shard.ready ();
            Clock.after (Core.Time.Span.create ~sec:5 ())
            >>> (fun _ -> Mvar.put identify_lock () >>> ignore);
            J.(member "session_id" data |> to_string_option)
        end else None in
        Event.handle_event ~ev:t data;
        return { shard with
            seq = seq;
            session = session;
        }

    let set_status ~(status:Yojson.Safe.json) shard =
        let payload = match status with
        | `Assoc [("name", `String name); ("type", `Int t)] ->
            `Assoc [
                ("status", `String "online");
                ("afk", `Bool false);
                ("since", `Null);
                ("game", `Assoc [
                    ("name", `String name);
                    ("type", `Int t)
                ])
            ]
        | `String name ->
            `Assoc [
                ("status", `String "online");
                ("afk", `Bool false);
                ("since", `Null);
                ("game", `Assoc [
                    ("name", `String name);
                    ("type", `Int 0)
                ])
            ]
        | _ -> raise Invalid_Payload
        in
        Ivar.read shard.ready >>= fun _ ->
        push_frame ~payload ~ev:STATUS_UPDATE shard

    let request_guild_members ?(query="") ?(limit=0) ~guild shard =
        let payload = `Assoc [
            ("guild_id", `String (Int.to_string guild));
            ("query", `String query);
            ("limit", `Int limit);
        ] in
        Ivar.read shard.ready >>= fun _ ->
        push_frame ~payload ~ev:REQUEST_GUILD_MEMBERS shard

    let initialize ?data shard =
        let module J = Yojson.Safe.Util in
        let _ = match data with
        | Some data -> Ivar.fill shard.hb_interval (Time.Span.create ~ms:J.(member "heartbeat_interval" data |> to_int) ())
        | None -> raise Failure_to_Establish_Heartbeat
        in
        let shards = [`Int (fst shard.id); `Int (snd shard.id)] in
        match shard.session with
        | None -> begin
            Mvar.take identify_lock >>= fun () ->
            Logs.debug (fun m -> m "Identifying shard [%d, %d]" (fst shard.id) (snd shard.id));
            let payload = `Assoc [
                ("token", `String !Client_options.token);
                ("properties", `Assoc [
                    ("$os", `String Sys.os_type);
                    ("$device", `String "dis.ml");
                    ("$browser", `String "dis.ml")
                ]);
                ("compress", `Bool false); (* TODO add compression handling*)
                ("large_threshold", `Int 250);
                ("shard", `List shards);
            ] in
            push_frame ~payload ~ev:IDENTIFY shard
            >>| fun s -> s
        end
        | Some s ->
            let payload = `Assoc [
                ("token", `String !Client_options.token);
                ("session_id", `String s);
                ("seq", `Int shard.seq)
            ] in
            push_frame ~payload ~ev:RESUME shard

    let handle_frame ~f shard =
        let module J = Yojson.Safe.Util in
        let op = J.(member "op" f |> to_int) |> Opcode.from_int in
        match op with
        | DISPATCH -> dispatch ~payload:f shard
        | HEARTBEAT -> heartbeat shard
        | INVALID_SESSION -> begin
            Logs.err (fun m -> m "Received OP 9 on Shard [%d, %d]: %s" (fst shard.id) (snd shard.id) (Yojson.Safe.pretty_to_string f));
            if J.(member "d" f |> to_bool) then
                initialize shard
            else begin
                initialize { shard with session = None; }
            end
        end
        | RECONNECT -> initialize shard
        | HELLO -> initialize ~data:(J.member "d" f) shard
        | HEARTBEAT_ACK -> return shard
        | opcode ->
            Logs.warn (fun m -> m "Invalid Opcode: %s" (Opcode.to_string opcode));
            return shard

    let rec make_client
        ~initialized
        ~extra_headers
        ~app_to_ws
        ~ws_to_app
        ~net_to_ws
        ~ws_to_net
        uri =
        client
            ~initialized
            ~extra_headers
            ~app_to_ws
            ~ws_to_app
            ~net_to_ws
            ~ws_to_net
            uri
            >>> fun res ->
                match res with
                | Ok () -> ()
                | Error _ ->
                    let backoff = Time.Span.create ~ms:500 () in
                    Clock.after backoff >>> (fun () ->
                    make_client
                        ~initialized
                        ~extra_headers
                        ~app_to_ws
                        ~ws_to_app
                        ~net_to_ws
                        ~ws_to_net
                        uri)


    let create ~url ~shards () =
        let open Core in
        let uri = (url ^ "?v=6&encoding=json") |> Uri.of_string in
        let extra_headers = Http.Base.process_request_headers () in
        let host = Option.value_exn ~message:"no host in uri" Uri.(host uri) in
        let port =
            match Uri.port uri, Uri_services.tcp_port_of_uri uri with
            | Some p, _ -> p
            | None, Some p -> p
            | _ -> 443 in
        let scheme = Option.value_exn ~message:"no scheme in uri" Uri.(scheme uri) in
        let tcp_fun (net_to_ws, ws_to_net) =
            (* Writer.monitor ws_to_net
            |> Monitor.detach_and_get_error_stream
            |> Stream.iter ~f:(fun e -> Logs.err (fun m -> m "Socket Connection Error: %s" (Exn.sexp_of_t e |> Sexp.to_string_hum))); *)
            let (app_to_ws, write) = Pipe.create () in
            let (read, ws_to_app) = Pipe.create () in
            let initialized = Ivar.create () in
            make_client
                ~initialized
                ~extra_headers
                ~app_to_ws
                ~ws_to_app
                ~net_to_ws
                ~ws_to_net
                uri;
            Ivar.read initialized >>| fun () ->
            {
                pipe = (read, write);
                ready = Ivar.create ();
                hb_interval = Ivar.create ();
                seq = 0;
                id = shards;
                session = None;
                url;
                _internal = (net_to_ws, ws_to_net);
            }
        in
        match Unix.getaddrinfo host (string_of_int port) [] with
        | [] -> failwithf "DNS resolution failed for %s" host ()
        | { ai_addr; _ } :: _ ->
            let addr =
            match scheme, ai_addr with
            | _, ADDR_UNIX path -> `Unix_domain_socket path
            | "https", ADDR_INET (h, p)
            | "wss", ADDR_INET (h, p) ->
                let h = Ipaddr_unix.of_inet_addr h in
                `OpenSSL (h, p, Conduit_async.V2.Ssl.Config.create ())
            | _, ADDR_INET (h, p) ->
                let h = Ipaddr_unix.of_inet_addr h in
                `TCP (h, p)
            in
            Conduit_async.V2.connect addr >>= tcp_fun

    let shutdown_clean shard =
        let (_,w) = shard._internal in
        Writer.close w

    let recreate shard =
        shutdown_clean shard >>= fun () ->
        create ~url:(shard.url) ~shards:(shard.id) ()
end

type t = {
    shards: (Shard.shard Shard.t) list;
}

let start ?count () =
    let module J = Yojson.Safe.Util in
    Http.get_gateway_bot () >>= fun data ->
    let data = match data with
    | Ok d -> d
    | Error e -> Error.raise e
    in
    let url = J.(member "url" data |> to_string) in
    let count = match count with
    | Some c -> c
    | None -> J.(member "shards" data |> to_int)
    in
    let shard_list = (0, count) in
    let rec ev_loop (t:Shard.shard Shard.t) =
        let (read, _) = t.state.pipe in
        Pipe.read read
        >>= fun frame ->
        (match Shard.parse frame with
        | Some f -> begin
            Shard.handle_frame ~f t.state
            >>| fun s -> t.state <- s; t
        end
        | None -> begin
            Shard.recreate t.state
            >>| fun s -> t.state <- s; t
        end)
        >>= fun t ->
        ev_loop t
    in
    let rec gen_shards l a =
        match l with
        | (id, total) when id >= total -> return a
        | (id, total) ->
            Shard.create ~url ~shards:(id, total) ()
            >>= fun shard ->
            let t = Shard.{ state = shard; } in
            let _ = Ivar.read t.state.hb_interval >>> fun hb -> Clock.every ~continue_on_error:true hb (fun () -> Shard.heartbeat t.state >>> ignore) in
            ev_loop t >>> ignore;
            gen_shards (id+1, total) (t :: a)
    in
    gen_shards shard_list []
    >>| fun shards ->
    { shards; }

let set_status ~status sharder =
    Deferred.all @@ List.map ~f:(fun t ->
        Shard.set_status ~status t.state
    ) sharder.shards

let set_status_with ~f sharder =
    Deferred.all @@ List.map ~f:(fun t ->
        Shard.set_status ~status:(f t.state) t.state
    ) sharder.shards

let request_guild_members ?query ?limit ~guild sharder =
    Deferred.all @@ List.map ~f:(fun t ->
        Shard.request_guild_members ~guild ?query ?limit t.state
    ) sharder.shards

let shutdown_all sharder =
    Deferred.all @@ List.map ~f:(fun t ->
        Shard.shutdown_clean t.state
    ) sharder.shards