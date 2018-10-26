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

module ShardMap = Map.Make(
    struct
        type t = int
        let compare: int -> int -> int = Pervasives.compare
    end
)

module Shard = struct
    type t = {
        send: (Frame.t -> unit Lwt.t);
        recv: (unit -> Frame.t Lwt. t);
        id: int;
        hb_interval: int;
        session_id: string;
        seq: int;
    }

    let send payload shard =
        payload
        |> shard.send

    let wrap_payload d op =
        `Assoc [
            ("op", `Int op);
            ("d", d)
        ]

    let create_frame content =
        Frame.create ~content ()

    let identify ?(threshold=250) shard total token =
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

    let resume shard token =
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
    let connect ~options uri id total token =
        let url = Uri.to_string uri in
        let ip = Ipaddr.V4 Ipaddr.V4.any in
        Websocket_lwt.with_connection (`TLS (`Hostname url, `IP ip, `Port 443)) uri
        >|= fun (recv, send) ->
        let shard = { send; recv; hb_interval = 42500; id; session_id = ""; seq = 0; } in
        heartbeat shard >>= (fun _ ->
            identify shard total token (* This needs to be handled, I'm just pleasing the compiler *)
        ) |> ignore;
        shard
end

type t = {
    shards: Shard.t ShardMap.t;
    gateway_url: Uri.t;
    token: string;
}

let create_shard ?(options=[]) manager =
    let id = (ShardMap.cardinal manager.shards) + 1 in
    Shard.connect ~options manager.gateway_url id (ShardMap.cardinal manager.shards) manager.token
    >|= fun shard ->
    ShardMap.add id shard manager.shards

let update_shard id shard manager =
    match ShardMap.exists (fun k _ -> id == k) manager.shards with
    | true -> ShardMap.add id shard manager.shards
    | false -> manager.shards

let heartbeat manager id =
    let shard = ShardMap.find id manager.shards in
    Shard.heartbeat shard

let identify manager id =
    let total = ShardMap.cardinal manager.shards in
    let shard = ShardMap.find id manager.shards in
    Shard.identify shard total manager.token

let resume manager id =
    let shard = ShardMap.find id manager.shards in
    Shard.resume shard manager.token