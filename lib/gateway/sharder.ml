open Async
open Core
open Decompress
open Websocket_async

exception Invalid_Payload
exception Failure_to_Establish_Heartbeat
exception Inflate_error of Zlib_inflate.error

let window = Window.create ~witness:B.bytes

let decompress src =
    let in_buf = Bytes.create 0xFFFF in
    let out_buf = Bytes.create 0xFFFF in
    let window = Window.reset window in
    let pos = ref 0 in
    let src_len = String.length src in
    let res = Buffer.create (src_len) in
    Zlib_inflate.bytes in_buf out_buf
    (fun dst ->
        let len = min 0xFFFF (src_len - !pos) in
        Caml.Bytes.blit_string src !pos dst 0 len;
        pos := !pos + len;
        len)
    (fun obuf len ->
        Buffer.add_subbytes res obuf 0 len; 0xFFFF)
    (Zlib_inflate.default ~witness:B.bytes window)
    |> function
    | Ok _ -> Buffer.contents res
    | Error exn -> raise (Inflate_error exn)

module Shard = struct
    type shard =
    { compress: bool
    ; id: int * int
    ; hb_interval: Time.Span.t Ivar.t
    ; hb_stopper: unit Ivar.t
    ; large_threshold: int
    ; pipe: Frame.t Pipe.Reader.t * Frame.t Pipe.Writer.t
    ; ready: unit Ivar.t
    ; seq: int
    ; session: string option
    ; url: string
    ; _internal: Reader.t * Writer.t
    }

    type 'a t =
    { mutable state: 'a
    ; mutable stopped: bool
    ; mutable can_resume: bool
    }

    let identify_lock = Mvar.create ()
    let _ = Mvar.set identify_lock ()

    let parse ~compress (frame:[`Ok of Frame.t | `Eof]) =
        match frame with
        | `Ok s -> begin
            let open Frame.Opcode in
            match s.opcode with
            | Text -> `Ok (Yojson.Safe.from_string s.content)
            | Binary ->
                if compress then `Ok (decompress s.content |> Yojson.Safe.from_string)
                    else `Error "Failed to decompress"
            | Close -> `Close s.content
            | op ->
                let op = Frame.Opcode.to_string op in
                `Error ("Unexpected opcode " ^ op)
        end
        | `Eof -> `Eof

    let push_frame ?payload ~ev shard =
        let content = match payload with
        | None -> ""
        | Some p ->
            Yojson.Safe.to_string @@ `Assoc [
                "op", `Int (Opcode.to_int ev);
                "d", p;
            ]
        in
        let (_, write) = shard.pipe in
        Pipe.write_if_open write @@ Frame.create ~content ()
        >>| fun () ->
        shard

    let heartbeat shard =
        match shard.seq with
        | 0 -> return shard
        | i ->
            Logs.debug (fun m -> m "Heartbeating - Shard: [%d, %d] - Seq: %d" (fst shard.id) (snd shard.id) (shard.seq));
            push_frame ~payload:(`Int i) ~ev:HEARTBEAT shard

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
        end else shard.session in
        Event.handle_event ~ev:t data;
        return
        { shard with seq = seq
        ; session = session
        }

    let set_status ?(status="online") ?(kind=0) ?name ?since shard =
        let since = Option.(since >>| (fun v -> `Int v) |> value ~default:`Null) in
        let game = match name with
            | Some name -> `Assoc [ "name", `String name; "type", `Int kind ]
            | None -> `Null
        in
        let payload = `Assoc
            [ "status", `String status
            ; "afk", `Bool false
            ; "since", since
            ; "game", game
            ]
        in
        Ivar.read shard.ready >>= fun _ ->
        push_frame ~payload ~ev:STATUS_UPDATE shard

    let request_guild_members ?(query="") ?(limit=0) ~guild shard =
        let payload = `Assoc
            [ "guild_id", `String (Int.to_string guild)
            ; "query", `String query
            ; "limit", `Int limit
            ]
        in
        Ivar.read shard.ready >>= fun _ ->
        push_frame ~payload ~ev:REQUEST_GUILD_MEMBERS shard

    let initialize ?data shard =
        let module J = Yojson.Safe.Util in
        let _ = match data with
        | Some data -> Ivar.fill_if_empty shard.hb_interval (Time.Span.create ~ms:J.(member "heartbeat_interval" data |> to_int) ())
        | None -> raise Failure_to_Establish_Heartbeat
        in
        let shards = [`Int (fst shard.id); `Int (snd shard.id)] in
        match shard.session with
        | None -> begin
            Mvar.take identify_lock >>= fun () ->
            Logs.debug (fun m -> m "Identifying shard [%d, %d]" (fst shard.id) (snd shard.id));
            let payload = `Assoc
                [ "token", `String !Client_options.token
                ; "properties", `Assoc
                    [ "$os", `String Sys.os_type
                    ; "$device", `String "dis.ml"
                    ; "$browser", `String "dis.ml"
                    ]
                ; "compress", `Bool shard.compress
                ; "large_threshold", `Int shard.large_threshold
                ; "shard", `List shards
                ]
            in
            push_frame ~payload ~ev:IDENTIFY shard
            >>| fun s -> s
        end
        | Some s ->
            let payload = `Assoc
                [ "token", `String !Client_options.token
                ; "session_id", `String s
                ; "seq", `Int shard.seq
                ]
            in
            push_frame ~payload ~ev:RESUME shard

    let handle_frame ~f shard =
        let module J = Yojson.Safe.Util in
        let op = J.(member "op" f |> to_int) |> Opcode.from_int in
        match op with
        | DISPATCH -> dispatch ~payload:f shard
        | HEARTBEAT -> heartbeat shard
        | INVALID_SESSION -> begin
            Logs.err (fun m -> m "Invalid Session on Shard [%d, %d]: %s" (fst shard.id) (snd shard.id) (Yojson.Safe.pretty_to_string f));
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
        ?(ms=500)
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
                    let backoff = Time.Span.create ~ms () in
                    Clock.after backoff >>> (fun () ->
                    make_client
                        ~initialized
                        ~extra_headers
                        ~app_to_ws
                        ~ws_to_app
                        ~net_to_ws
                        ~ws_to_net
                        ~ms:(min 60_000 (ms * 2))
                        uri)


    let create ~url ~shards ?(compress=true) ?(large_threshold=100) () =
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
            { pipe = (read, write)
            ; ready = Ivar.create ()
            ; hb_interval = Ivar.create ()
            ; hb_stopper = Ivar.create ()
            ; seq = 0
            ; id = shards
            ; session = None
            ; url
            ; large_threshold
            ; compress
            ; _internal = (net_to_ws, ws_to_net)
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

    let shutdown ?(clean=false) ?(restart=true) t =
        let _ = clean in
        t.can_resume <- restart;
        t.stopped <- true;
        Logs.debug (fun m -> m "Performing shutdown. Shard [%d, %d]" (fst t.state.id) (snd t.state.id));
        Pipe.write_if_open (snd t.state.pipe) (Frame.close 1001)
        >>= fun () ->
        Ivar.fill_if_empty t.state.hb_stopper ();
        Pipe.close_read (fst t.state.pipe);
        Writer.close (snd t.state._internal)
end

type t = { shards: (Shard.shard Shard.t) list }

let start ?count ?compress ?large_threshold () =
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
    Logs.info (fun m -> m "Connecting to %s" url);
    let rec ev_loop (t:Shard.shard Shard.t) =
        let step (t:Shard.shard Shard.t) =
            Pipe.read (fst t.state.pipe) >>= fun frame -> 
            begin match Shard.parse ~compress:t.state.compress frame with
            | `Ok f ->
                Shard.handle_frame ~f t.state >>| fun s ->
                t.state <- s
            | `Close c ->
                Logs.warn (fun m -> m "Close frame received. Code: %s" c);
                Shard.shutdown t
            | `Error e ->
                Logs.warn (fun m -> m "Websocket soft error: %s" e);
                return ()
            | `Eof ->
                Logs.warn (fun m -> m "Websocket closed unexpectedly");
                Shard.shutdown t
            end >>| fun () -> t
        in
        if t.stopped then return ()
        else step t >>= ev_loop
    in
    let rec gen_shards l a =
        match l with
        | (id, total) when id >= total -> return a
        | (id, total) ->
            let wrap ?(reuse:Shard.shard Shard.t option) state = match reuse with
            | Some t ->
                t.state <- state;
                t.stopped <- false;
                return t
            | None ->
                return Shard.{ state
                    ; stopped = false
                    ; can_resume = true
                    }
            in
            let create () =
                Shard.create ~url ~shards:(id, total) ?compress ?large_threshold ()
            in
            let rec bind (t:Shard.shard Shard.t) =
                let _ = Ivar.read t.state.hb_interval >>> fun hb ->
                    Clock.every'
                    ~stop:(Ivar.read t.state.hb_stopper)
                    ~continue_on_error:true
                    hb (fun () -> Shard.heartbeat t.state >>| ignore) in
                ev_loop t >>> (fun () -> Logs.debug (fun m -> m "Event loop stopped."));
                Pipe.closed (fst t.state.pipe) >>> (fun () -> if t.can_resume then
                create () >>= wrap ~reuse:t >>= bind >>> ignore);
                return t
            in
            create () >>= wrap >>= bind >>= fun t ->
            gen_shards (id+1, total) (t :: a)
    in
    gen_shards shard_list []
    >>| fun shards ->
    { shards }

let set_status ?status ?kind ?name ?since sharder =
    Deferred.all @@ List.map ~f:(fun t ->
        Shard.set_status ?status ?kind ?name ?since t.state
    ) sharder.shards

let request_guild_members ?query ?limit ~guild sharder =
    Deferred.all @@ List.map ~f:(fun t ->
        Shard.request_guild_members ~guild ?query ?limit t.state
    ) sharder.shards

let shutdown_all ?restart sharder =
    Deferred.all @@ List.map ~f:(fun t ->
        Shard.shutdown ~clean:true ?restart t
    ) sharder.shards