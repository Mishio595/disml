open Lwt.Infix
open Websocket

module Opcode = struct
    type t =
        | DISPATCH
        | HEARTBEAT
        | IDENTIFY
        | STATUS_UPDATE
        | VOICE_STATE_UPDATE
        | RESUME
        | RECONNECT
        | REQUEST_GUILD_MEMBERS
        | INVALID_SESSION
        | HELLO
        | HEARTBEAT_ACK

    let to_int = function
        | DISPATCH -> 0
        | HEARTBEAT -> 1
        | IDENTIFY -> 2
        | STATUS_UPDATE -> 3
        | VOICE_STATE_UPDATE -> 4
        | RESUME -> 6
        | RECONNECT -> 7
        | REQUEST_GUILD_MEMBERS -> 8
        | INVALID_SESSION -> 9
        | HELLO -> 10
        | HEARTBEAT_ACK -> 11

    let to_string = function
        | DISPATCH -> "DISPATCH"
        | HEARTBEAT -> "HEARTBEAT"
        | IDENTIFY -> "IDENTIFY"
        | STATUS_UPDATE -> "STATUS_UPDATE"
        | VOICE_STATE_UPDATE -> "VOICE_STATE_UPDATE"
        | RESUME -> "RESUME"
        | RECONNECT -> "RECONNECT"
        | REQUEST_GUILD_MEMBERS -> "REQUEST_GUILD_MEMBER"
        | INVALID_SESSION -> "INVALID_SESSION"
        | HELLO -> "HELLO"
        | HEARTBEAT_ACK -> "HEARTBEAT_ACK"
end

module Shard = struct
    type t = {
        send: (Frame.t -> unit Lwt.t);
        id: int;
        hb_interval: int;
        session_id: string;
        seq: int;
    }

    let init ?(hb_interval=42500) ?(session_id="") ?(seq=0)
        send id =
        { send; recv; id; hb_interval; session_id; seq; }

    let compare s1 s2 =
        Pervasives.compare s1.id s2.id

    let send payload shard =
        payload
        |> shard.send

    let process_frame shard frame = 
        (* Add processor *)

    let wrap_payload d op =
        `Assoc [
            ("op", `Int op);
            ("d", d)
        ]

    let create_frame content =
        Frame.create ~content ()

    let identify ?(threshold=250) total token shard =
        let p = wrap_payload (`Assoc [
            ("token", `String token);
            ("properties", `Assoc [
                ("$os", `String Sys.os_type);
                ("$browser", `String "animus");
                ("$device", `String "animus");
            ]);
            ("large_threshold", `Int threshold);
            ("shard", `List [`Int shard.id; `Int total]);
        ]) (Opcode.to_int IDENTIFY) in
        let p = create_frame (Yojson.Basic.to_string p) in
        send p shard

    let resume token shard =
        let p = wrap_payload (`Assoc [
            ("token", `String token);
            ("session_id", `String shard.session_id);
            ("seq", `Int shard.seq);
        ]) (Opcode.to_int RESUME) in
        let p = create_frame (Yojson.Basic.to_string p) in
        send p shard

    let heartbeat shard =
        let p = wrap_payload (`Int shard.seq) (Opcode.to_int HEARTBEAT) in
        let p = create_frame (Yojson.Basic.to_string p) in
        send p shard

    (* Use options *)
    let connect ~options ~uri ~id ~total ~token () =
        let url = uri |> Uri.to_string in
        let ip = Ipaddr.V4 Ipaddr.V4.any in
        Websocket_lwt.with_connection (`TLS (`Hostname url, `IP ip, `Port 443)) uri (* Maybe use upgrade_connection? *)
        >|= fun (recv, send) ->
        let shard = init send id in
        heartbeat shard >>= (fun _ ->
            identify shard total token 
        ) |> ignore; (* This feels really hacky *)
        let handle_frame = process_frame shard in
        let rec recv_loop () = recv () >>= handle_frame >>= recv_loop () in
        recv_loop (); (* This is a bad way to do this. We should abstract the shard.send away and use Lwt.choose *)
        shard
end

module ShardSet = Set.Make(Shard)

type t = {
    shards: Shard.t ShardSet.t;
    gateway_url: Uri.t;
    token: string;
}

let create_shard ?(options=[]) manager =
    let id = (ShardSet.cardinal manager.shards) + 1 in
    Shard.connect ~options ~uri:manager.gateway_url ~id ~total:(ShardSet.cardinal manager.shards) ~token:manager.token ()
    >|= fun shard ->
    ShardSet.add shard manager.shards

let update_shard shard manager =
    match ShardSet.mem shard manager.shards with
    | true -> ShardSet.add shard manager.shards
    | false -> manager.shards

let heartbeat shard manager =
    Shard.heartbeat shard

let identify shard manager =
    let total = ShardSet.cardinal manager.shards in
    Shard.identify total manager.token shard

let resume shard manager =
    Shard.resume manager.token shard