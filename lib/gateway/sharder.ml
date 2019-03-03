open Lwt.Infix
open Decompress
open Websocket
open Websocket_lwt

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
    ; hb_interval: int Lwt.t * int Lwt.u
    ; hb_stopper: Lwt_engine.event option
    ; id: int
    ; large_threshold: int
    ; ready: unit Lwt.t * unit Lwt.u
    ; recv: (unit -> Frame.t Lwt.t)
    ; send: (Frame.t -> unit Lwt.t)
    ; seq: int
    ; session: string option
    ; shard_count: int
    ; url: string
    }

    type 'a t =
    { mutable state: 'a
    ; mutable stop: unit Lwt.t * unit Lwt.u
    ; mutable can_resume: bool
    }

    let identify_lock = Lwt_mvar.create ()

    let parse ~compress (frame:Frame.t) =
        let open Frame.Opcode in
        match frame.opcode with
        | Text -> `Ok (Yojson.Safe.from_string frame.content)
        | Binary ->
            if compress then `Ok (decompress frame.content |> Yojson.Safe.from_string)
                else `Error "Failed to decompress"
        | Close -> `Close frame
        | op ->
            let op = Frame.Opcode.to_string op in
            `Error ("Unexpected opcode " ^ op)

    let push_frame ?payload ~ev shard =
        let content = match payload with
        | None -> ""
        | Some p ->
            Yojson.Safe.to_string @@ `Assoc
            [ "op", `Int (Opcode.to_int ev)
            ; "d", p
            ]
        in
        Frame.create ~content ()
        |> shard.send >|= fun () ->
        shard

    let heartbeat shard =
        match shard.seq with
        | 0 -> Lwt.return shard
        | i ->
            Logs_lwt.info (fun m -> m "Heartbeating - Shard: [%d, %d] - Seq: %d" shard.id shard.shard_count shard.seq) >>= fun () ->
            push_frame ~payload:(`Int i) ~ev:HEARTBEAT shard

    let dispatch ~payload shard =
        let module J = Yojson.Safe.Util in
        let seq = J.(member "s" payload |> to_int) in
        let t = J.(member "t" payload |> to_string) in
        let data = J.member "d" payload in
        let session = if t = "READY" then begin
            Lwt.wakeup_later (snd shard.ready) ();
            let _ = Lwt_engine.on_timer 5.0 false
                (fun _ -> Lwt.async (fun () -> Lwt_mvar.put identify_lock ())) in
            J.(member "session_id" data |> to_string_option)
        end else shard.session in
        Event.handle_event ~ev:t data >|= fun () ->
        { shard with seq = seq
        ; session = session
        }

    let set_status ?(status="online") ?(kind=0) ?name ?since ?url shard = 
        let since = Option.(map since ~f:(fun v -> `Int v) |> value ~default:`Null) in
        let url = Option.(map url ~f:(fun v -> `String v) |> value ~default:`Null) in
        let game = match name with
            | Some name -> `Assoc
                [ "name", `String name
                ; "type", `Int kind
                ; "url", url
                ]
            | None -> `Null
        in
        let payload = `Assoc
            [ "status", `String status
            ; "afk", `Bool false
            ; "since", since
            ; "game", game
            ]
        in
        fst shard.ready >>= fun _ ->
        push_frame ~payload ~ev:STATUS_UPDATE shard

    let request_guild_members ?(query="") ?(limit=0) ~guild shard =
        let payload = `Assoc
            [ "guild_id", `String (string_of_int guild)
            ; "query", `String query
            ; "limit", `Int limit
            ]
        in
        fst shard.ready >>= fun _ ->
        push_frame ~payload ~ev:REQUEST_GUILD_MEMBERS shard

    let initialize ?data shard =
        let module J = Yojson.Safe.Util in
        let _ = match data with
        | Some data -> Lwt.wakeup_later (snd shard.hb_interval) J.(member "heartbeat_interval" data |> to_int)
        | None -> raise Failure_to_Establish_Heartbeat
        in
        let shards = [`Int shard.id; `Int shard.shard_count] in
        match shard.session with
        | None -> begin
            Lwt_mvar.take identify_lock >>= fun () ->
            Logs_lwt.info (fun m -> m "Identifying shard [%d, %d]" shard.id shard.shard_count) >>= fun () ->
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
            Logs_lwt.warn (fun m -> m "Invalid Session on Shard [%d, %d]: %s" shard.id shard.shard_count (Yojson.Safe.pretty_to_string f)) >>= fun () ->
            if J.(member "d" f |> to_bool) then initialize shard
            else initialize { shard with session = None; }
        end
        | RECONNECT -> initialize shard
        | HELLO -> initialize ~data:(J.member "d" f) shard
        | HEARTBEAT_ACK -> Lwt.return shard
        | opcode ->
            Logs_lwt.warn (fun m -> m "Invalid Opcode: %s" (Opcode.to_string opcode)) >|= fun () ->
            shard

    let make_client ?extra_headers uri =
        let uri = Uri.with_scheme uri (Some "https") in
        Resolver_lwt.resolve_uri ~uri Resolver_lwt_unix.system >>= fun endp ->
        Conduit_lwt_unix.(
            endp_to_client ~ctx:default_ctx endp >>= fun client ->
            with_connection ?extra_headers ~ctx:default_ctx client uri)

    let create ~url ~shards ?(compress=true) ?(large_threshold=100) () =
        let uri = Uri.(with_query' (of_string url) ["encoding", "json"; "v", "6"]) in
        let extra_headers = Http.Base.process_request_headers () in
        make_client ~extra_headers uri >|= fun (recv, send) ->
        { compress
        ; hb_interval = Lwt.wait ()
        ; hb_stopper = None
        ; id = fst shards
        ; large_threshold
        ; ready = Lwt.wait ()
        ; recv
        ; send
        ; seq = 0
        ; session = None
        ; shard_count = snd shards
        ; url
        }

    let shutdown ?(clean=false) ?(restart=true) t =
        let _ = clean in
        t.can_resume <- restart;
        Lwt.wakeup_later (snd t.stop) ();
        Logs_lwt.info (fun m -> m "Performing shutdown. Shard [%d, %d]" t.state.id t.state.shard_count) >>= fun () ->
        t.state.send (Frame.close 1001) >|= fun () ->
        Option.map t.state.hb_stopper ~f:(fun ev -> Lwt_engine.stop_event ev)
        |> ignore
end

type t = { shards: (Shard.shard Shard.t) list }

let start ?count ?compress ?large_threshold () =
    let module J = Yojson.Safe.Util in
    Http.get_gateway_bot () >>= fun data ->
    let data = match data with
    | Ok d -> d
    | Error e -> Base.Error.(of_string e |> raise)
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
            t.state.recv () >>= function frame ->
            begin match Shard.parse ~compress:t.state.compress frame with
            | `Ok f ->
                Shard.handle_frame ~f t.state >|= fun s ->
                t.state <- s
            | `Close c ->
                Logs_lwt.warn (fun m -> m "Close frame received. %s" (Frame.show c)) >>= fun () ->
                Shard.shutdown t
            | `Error e ->
                Logs_lwt.warn (fun m -> m "Websocket soft error: %s" e) >>= fun () ->
                Lwt.return_unit
            | `Eof ->
                Logs_lwt.warn (fun m -> m "Websocket closed unexpectedly") >>= fun () ->
                Shard.shutdown t
            end >|= fun () -> t
        in
        if not (Lwt.is_sleeping (fst t.stop)) then Lwt.return_unit
        else step t >>= ev_loop
    in
    let rec gen_shards l a =
        match l with
        | (id, total) when id >= total -> Lwt.return a
        | (id, total) ->
            let wrap ?(reuse:Shard.shard Shard.t option) state = match reuse with
            | Some t ->
                t.state <- state;
                t.stop <- Lwt.wait ();
                Lwt.return t
            | None ->
                Lwt.return Shard.{ state
                    ; stop = Lwt.wait ()
                    ; can_resume = true
                    }
            in
            let create () =
                Shard.create ~url ~shards:(id, total) ?compress ?large_threshold ()
            in
            let rec bind (t:Shard.shard Shard.t) =
                Lwt.async (fun () ->
                    fst t.state.hb_interval >>= fun hb ->
                        Logs_lwt.info (fun m -> m "Starting heartbeats") >|= fun () ->
                        let hb = float_of_int hb /. 1000.0 in
                        let ev = Lwt_engine.on_timer hb true
                            (fun _ -> Lwt.async (fun () -> Shard.heartbeat t.state)) in
                        t.state <- { t.state with hb_stopper = Some ev }
                    );
                Lwt.async (fun () -> ev_loop t >>= fun () -> Logs_lwt.info (fun m -> m "Event loop stopped."));
                Lwt.async (fun () -> fst t.stop >>= fun () ->
                    if t.can_resume then create () >>= wrap ~reuse:t >>= bind >|= ignore
                    else Lwt.return_unit);
                Lwt.return t
            in
            create () >>= wrap >>= bind >>= fun t ->
            gen_shards (id+1, total) (t :: a)
    in
    gen_shards shard_list []
    >|= fun shards ->
    { shards }

let set_status ?status ?kind ?name ?since ?url sharder =
    List.map (fun (t:Shard.shard Shard.t) ->
        Shard.set_status ?status ?kind ?name ?since ?url t.state >|= ignore)
        sharder.shards
    |> Lwt.join

let request_guild_members ?query ?limit ~guild sharder =
    List.map (fun (t:Shard.shard Shard.t) ->
        Shard.request_guild_members ~guild ?query ?limit t.state >|= ignore)
        sharder.shards
    |> Lwt.join

let shutdown_all ?restart sharder =
    List.map (fun t ->
        Shard.shutdown ~clean:true ?restart t)
        sharder.shards
    |> Lwt.join
