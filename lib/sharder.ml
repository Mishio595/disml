module Make(H: S.Http) = struct
    open Async
    open Core
    open Websocket_async

    exception Invalid_Payload
    exception Failure_to_Establish_Heartbeat

    let token = H.token

    module Shard = struct
        type shard = {
            hb: unit Ivar.t option;
            seq: int;
            session: string option;
            pipe: Frame.t Pipe.Reader.t * Frame.t Pipe.Writer.t;
            ready: unit Ivar.t;
            url: string;
            id: int * int;
        }

        type 'a t = {
            mutable state: 'a;
            mutable binds: ('a -> unit) list;
        }

        let identify_lock = Mutex.create ()

        let bind ~f t =
            t.binds <- f :: t.binds

        let parse (frame:[`Ok of Frame.t | `Eof]) =
            match frame with
            | `Ok s -> begin
                let open Frame.Opcode in
                match s.opcode with
                | Text -> Some (Yojson.Basic.from_string s.content)
                | _ -> None
            end
            | `Eof -> None

        let push_frame ?payload ~ev shard =
            print_endline @@ "Pushing frame. OP: " ^ Opcode.to_string @@ ev;
            let content = match payload with
            | None -> ""
            | Some p ->
                Yojson.Basic.to_string @@ `Assoc [
                ("op", `Int (Opcode.to_int ev));
                ("d", p);
                ]
            in
            let (_, write) = shard.pipe in
            Pipe.write write @@ Frame.create ~content ()
            >>| fun () ->
            shard

        let heartbeat shard =
            let payload = match shard.seq with
            | 0 -> `Null
            | i -> `Int i
            in
            push_frame ~payload ~ev:HEARTBEAT shard

        let dispatch ~payload shard =
            let module J = Yojson.Basic.Util in
            let seq = J.(member "s" payload |> to_int) in
            let t = J.(member "t" payload |> to_string) in
            let data = J.member "d" payload in
            let session = J.(member "session_id" data |> to_string_option) in
            if t = "READY" then begin
                Ivar.fill_if_empty shard.ready ();
            end;
            return { shard with
                seq = seq;
                session = session;
            }

        let set_status ~(status:Yojson.Basic.json) shard =
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
                ("guild_id", `String (Snowflake.to_string guild));
                ("query", `String query);
                ("limit", `Int limit);
            ] in
            Ivar.read shard.ready >>= fun _ ->
            push_frame ~payload ~ev:REQUEST_GUILD_MEMBERS shard

        let initialize ?data shard =
            let module J = Yojson.Basic.Util in
            let hb = match shard.hb with
            | None -> begin
                match data with
                | Some data ->
                    let hb_interval = J.(member "heartbeat_interval" data |> to_int) in
                    let stop_hb = Ivar.create () in
                    let stopper i =
                        Ivar.read stop_hb
                        >>> fun () ->
                        Ivar.fill_if_empty i ()
                    in
                    let stop = Deferred.create stopper in
                    Clock.every'
                    ~continue_on_error:true
                    ~stop
                    (Core.Time.Span.create ~ms:hb_interval ())
                    (fun () -> heartbeat shard >>= fun _ -> return ());
                    stop_hb
                | None -> raise Failure_to_Establish_Heartbeat
            end
            | Some s -> s
            in
            let shard = { shard with hb = Some hb; } in
            let (cur, max) = shard.id in
            let shards = [`Int cur; `Int max] in
            match shard.session with
            | None -> begin
                Mutex.lock identify_lock;
                let payload = `Assoc [
                    ("token", `String token);
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
                >>| fun s -> begin
                Clock.after (Core.Time.Span.create ~sec:5 ())
                >>> (fun _ -> Mutex.unlock identify_lock);
                s
                end
            end
            | Some s ->
                let payload = `Assoc [
                    ("token", `String token);
                    ("session_id", `String s);
                    ("seq", `Int shard.seq)
                ] in
                push_frame ~payload ~ev:RESUME shard

        let handle_frame ~f shard =
            let module J = Yojson.Basic.Util in
            let op = J.(member "op" f |> to_int)
                |> Opcode.from_int
            in
            match op with
            | DISPATCH -> dispatch ~payload:f shard
            | HEARTBEAT -> heartbeat shard
            | INVALID_SESSION -> begin
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
                print_endline @@ "Invalid Opcode: " ^ Opcode.to_string opcode;
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
            let extra_headers = H.Base.process_request_headers () in
            let host = Option.value_exn ~message:"no host in uri" Uri.(host uri) in
            let port =
                match Uri.port uri, Uri_services.tcp_port_of_uri uri with
                | Some p, _ -> p
                | None, Some p -> p
                | _ -> 443 in
            let scheme = Option.value_exn ~message:"no scheme in uri" Uri.(scheme uri) in
            let tcp_fun (net_to_ws, ws_to_net) =
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
                    hb = None;
                    seq = 0;
                    id = shards;
                    session = None;
                    url;
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

        let recreate shard =
            print_endline "Reconnecting...";
            (match shard.hb with
            | Some hb -> Ivar.fill_if_empty hb ()
            | None -> ()
            );
            create ~url:(shard.url) ~shards:(shard.id) ()
    end

    type t = {
        shards: (Shard.shard Shard.t) list;
    }

    let start ?count () =
        let module J = Yojson.Basic.Util in
        H.get_gateway_bot () >>= fun data ->
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
                >>| fun s -> (t.state <- s; t)
            end
            | None -> begin
                Shard.recreate t.state
                >>| fun s -> (t.state <- s; t)
            end)
            >>= fun t ->
            List.iter ~f:(fun f -> f t.state) t.binds;
            ev_loop t
        in
        let rec gen_shards l a =
            match l with
            | (id, total) when id >= total -> return a
            | (id, total) ->
                Shard.create ~url ~shards:(id, total) ()
                >>= fun shard ->
                let t = Shard.{ state = shard; binds = []; } in
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
end