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
    }

    let parse (frame : Frame.t) =
        try
            frame.content
            |> Yojson.Basic.from_string
        with Yojson.Json_error err ->
            print_endline err;
            `String ""

    let encode term =
        let content = term |> Yojson.Basic.to_string in
        Frame.create ~content ()

    let push_frame ?payload shard (ev : Opcode.t) =
        print_endline @@ "Pushing frame. OP: " ^ Opcode.to_string @@ ev;
        let content = match payload with
        | None -> None
        | Some p ->
            Some (Yojson.Basic.to_string (`Assoc [
            ("op", `Int (Opcode.to_int ev));
            ("d", p);
        ]))
        in
        let frame = Frame.create ?content () in
        shard.send frame
        |> ignore;
        shard

    let initialize shard data =
        print_endline "Initializing...";
        let hb = match shard.hb with
        | None -> begin
            let hb_interval = List.assoc "heartbeat_interval" @@
                Yojson.Basic.Util.to_assoc data
                |> Yojson.Basic.Util.to_int
            in
            let seq = match shard.seq with
            | 0 -> `Null
            | i -> `Int i
            in
            let payload = `Assoc [
                ("op", `Int 1);
                ("d", seq);
            ] in
            Lwt_engine.on_timer
            (Float.of_int hb_interval)
            true
            (fun _ev -> push_frame ~payload shard HEARTBEAT |> ignore)
        end
        | Some s -> s
        in
        let shard = { shard with hb = Some hb; } in
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



    let handle_frame shard (term : Yojson.Basic.json) =
        Yojson.Basic.pretty_print Format.std_formatter term;
        print_newline ();
        match term with
        | `Assoc term -> begin
            let op = List.assoc "op" term
            |> Yojson.Basic.Util.to_int
            |> Opcode.from_int
            in
            match op with
            | DISPATCH -> print_endline "OP 0"; shard (* TODO dispatch *)
            | HEARTBEAT -> push_frame shard HEARTBEAT
            | RECONNECT -> print_endline "OP 7"; shard (* TODO reconnect *)
            | INVALID_SESSION -> print_endline "OP 9"; shard (* TODO invalid session *)
            | HELLO ->
                let data = List.assoc "d" term in
                initialize shard data
            | _opcode -> print_endline "no match"; shard
        end
        | _ -> shard

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
        let rec recv_forever shard = begin
            recv ()
            >>= fun frame ->
            Lwt.return @@ handle_frame shard @@ parse frame
            >>= fun shard -> recv_forever shard
        end in
        let shard = {
            send;
            recv;
            hb = None;
            seq = 0;
            shard = data.shards;
            session = None;
            token = data.token;
        } in
        recv_forever shard
end

type t = {
    shards: Shard.t list;
}