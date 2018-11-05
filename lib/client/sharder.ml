open Lwt.Infix
open Websocket
open Websocket_lwt_unix

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
        conn: Connected_client.t;
    }

    let parse frame =
        frame |> Frame.show |> Yojson.Basic.from_string

    let encode term =
        let content = term |> Yojson.Basic.to_string in
        Frame.create ~content ()

    let push_frame ?payload shard (ev : Opcode.t) =
        let content = match payload with
        | None -> None
        | Some p -> Some (Yojson.Basic.to_string p)
        in
        let frame = Frame.create ?content () in
        Connected_client.send shard.conn frame
        |> ignore;
        shard

    let initialize shard data =
        let hb = match shard.hb with
        | None -> begin
            let hb_interval = List.assoc "hb_interval" @@
                Yojson.Basic.Util.to_assoc data
                |> Yojson.Basic.Util.to_int
            in
            Lwt_engine.on_timer
            (Float.of_int hb_interval)
            true
            (fun _ev -> push_frame shard HEARTBEAT |> ignore)
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
                ("compress", `Bool true);
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
        match term with
        | `Assoc [
            ("op", `Int 0);
            ("t", `String t);
            ("s", `Int s);
            ("d", d)
            ] -> shard (* TODO dispatch *)
        | `Assoc [
            ("op", `Int 1)
            ] -> push_frame shard HEARTBEAT
        | `Assoc [
            ("op", `Int 7)
            ] -> shard (* TODO reconnect *)
        | `Assoc [
            ("op", `Int 9)
            ] -> shard (* TODO invalid session *)
        | `Assoc [
            ("op", `Int 10);
            ("d", data)
            ] -> initialize shard data
        | _data -> shard

    let create data =
        let uri = (data.url ^ "?v=7&encoding=json") |> Uri.of_string in
        let headers = Http.Base.process_request_headers () in
        let req = Cohttp_lwt.Request.make ~headers uri in
        let ic, oc = Lwt_io.pipe () in
        let client = Connected_client.create req (`TCP (V4 Ipaddr.V4.any, 443)) ic oc in
        let rec recv_forever shard = begin
            Connected_client.recv client
            >>= fun frame ->
            Lwt.return @@ handle_frame shard @@ parse frame
            >>= fun shard -> recv_forever shard
        end in
        let shard = {
            conn = client;
            hb = None;
            seq = 0;
            shard = data.shards;
            session = None;
            token = data.token;
        } in
        recv_forever shard |> ignore;
        shard
end

type t = {
    shards: Shard.t list;
}