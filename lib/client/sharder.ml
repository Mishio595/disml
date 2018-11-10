open Lwt.Infix
open Websocket

type data = {
    shards: int list;
    token: string;
    url: string;
}

module Shard = struct
    type t = {
        mutable hb: Lwt_engine.event option;
        mutable seq: int;
        session: string option;
        token: string;
        shard: int list;
        send: Frame.t -> unit Lwt.t;
        recv: unit -> Frame.t Lwt.t;
        ready: unit Lwt.t;
    }

    let parse (frame : Frame.t) =
        frame.content
        |> Yojson.Basic.from_string

    let encode term =
        let content = term |> Yojson.Basic.to_string in
        Frame.create ~content ()

    let push_frame ?payload shard (ev : Opcode.t) =
        print_endline @@ "Pushing frame. OP: " ^ Opcode.to_string @@ ev;
        let content = match payload with
        | None -> None
        | Some p ->
            Some (Yojson.Basic.to_string @@ `Assoc [
            ("op", `Int (Opcode.to_int ev));
            ("d", p);
            ])
        in
        let frame = Frame.create ?content () in
        shard.send frame
        |> ignore;
        shard

    let heartbeat shard =
        let seq = match shard.seq with
        | 0 -> `Null
        | i -> `Int i
        in
        let payload = `Assoc [
            ("op", `Int 1);
            ("d", seq);
        ] in
        push_frame ~payload shard HEARTBEAT

    let dispatch shard payload resolver =
        let t = List.assoc "t" payload
        |> Yojson.Basic.Util.to_string in
        let seq = List.assoc "s" payload
        |> Yojson.Basic.Util.to_int in
        let data = List.assoc "d" payload in
        shard.seq <- seq;
        let _ = match t with
        | "READY" -> Lwt.wakeup_later resolver ()
        | _ -> ()
        in
        Client.notify t data;
        shard

    let set_status shard game =
        let d = `Assoc [
            ("status", `String "online");
            ("afk", `Bool false);
            ("game", `Assoc [
                ("name", `String game);
                ("type", `Int 0)
            ])
        ] in
        let payload = `Assoc [
            ("op", `Int 3);
            ("d", d)
        ] in
        shard.ready >|= fun _ -> push_frame ~payload shard STATUS_UPDATE

    let initialize shard data =
        print_endline "Initializing...";
        let hb = match shard.hb with
        | None -> begin
            let hb_interval = List.assoc "heartbeat_interval" @@
                Yojson.Basic.Util.to_assoc data
                |> Yojson.Basic.Util.to_int
            in
            heartbeat shard |> ignore;
            Lwt_engine.on_timer
            (Float.of_int hb_interval /. 1000.0)
            true
            (fun _ev -> heartbeat shard |> ignore)
        end
        | Some s -> s
        in
        shard.hb <- Some hb;
        match shard.session with
        | None ->
            let payload = `Assoc [
                ("token", `String shard.token);
                ("properties", `Assoc [
                    ("$os", `String Sys.os_type);
                    ("$device", `String "animus");
                    ("$browser", `String "animus")
                ]);
                ("compress", `Bool false); (* TODO add compression handling*)
                ("large_threshold", `Int 250);
                ("shard", `List (List.map (fun i -> `Int i) shard.shard))
            ] in
            push_frame ~payload shard IDENTIFY
        | Some s ->
            let payload = `Assoc [
                ("token", `String shard.token);
                ("session_id", `String s);
                ("seq", `Int shard.seq)
            ] in
            push_frame ~payload shard RECONNECT

    let handle_frame shard (term : Yojson.Basic.json) resolver =
        match term with
        | `Assoc term -> begin
            Yojson.Basic.pretty_print Format.std_formatter @@ `Assoc term;
            print_newline ();
            let op = List.assoc "op" term
            |> Yojson.Basic.Util.to_int
            |> Opcode.from_int
            in
            match op with
            | DISPATCH -> dispatch shard term resolver
            | HEARTBEAT -> heartbeat shard
            | RECONNECT -> print_endline "OP 7"; shard (* TODO reconnect *)
            | INVALID_SESSION -> print_endline "OP 9"; shard (* TODO invalid session *)
            | HELLO ->
                let data = List.assoc "d" term in
                initialize shard data
            | HEARTBEAT_ACK -> shard
            | opcode -> print_endline @@ "Invalid Opcode:" ^ Opcode.to_string opcode; shard
        end
        | _ -> print_endline "Invalid payload"; shard

    let create data =
        let uri = (data.url ^ "?v=7&encoding=json") |> Uri.of_string in
        let http_uri = Uri.with_scheme uri (Some "https") in
        let headers = Http.Base.process_request_headers () in
        Resolver_lwt.resolve_uri ~uri:http_uri Resolver_lwt_unix.system >>= fun endp ->
        let ctx = Conduit_lwt_unix.default_ctx in
        Conduit_lwt_unix.endp_to_client ~ctx endp >>= fun client ->
        Websocket_lwt_unix.with_connection
            ~extra_headers:headers
            client
            uri
        >>= fun (recv, send) ->
        let (ready, ready_resolver) = Lwt.task () in
        let rec recv_forever s = begin
            s.recv ()
            >>= fun frame ->
            match frame.opcode with
            | Text ->
                let p = parse frame in
                handle_frame s p ready_resolver
                |> Lwt.return
            | _ -> Lwt.return s
            >>= fun s -> recv_forever s
        end in
        let shard = {
            send;
            recv;
            ready;
            hb = None;
            seq = 0;
            shard = data.shards;
            session = None;
            token = data.token;
        } in
        Lwt.return (shard, recv_forever shard) (* Not sure why the return is needed *)
end

type t = {
    shards: Shard.t list;
}