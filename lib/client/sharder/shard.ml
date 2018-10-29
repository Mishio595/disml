open Lwt.Infix
open Websocket

type t = {
    send: (Frame.t -> unit Lwt.t);
    id: int;
    total_shards: int;
    hb_interval: int;
    session_id: string;
    seq: int;
    token: string;
}

let init ?(hb_interval=42500) ?(session_id="") ?(seq=0) ~send ~id ~total_shards ~token () =
    { send; id; total_shards; hb_interval; session_id; seq; token; }

let push_frame shard frame =
    shard.send frame

let process_frame shard frame =
    let json = frame |> Yojson.Basic.from_string in
    match json with
    | `Assoc [("s", `Int _s); ("d", _d); ("t", `String _t); ("op", `Int op);] -> begin
        match op |> Opcode.from_int with
        | DISPATCH -> () (* dispatch t d  Need to write the dispatcher and other ops *)
        | HEARTBEAT -> ()
        | IDENTIFY -> ()
        | STATUS_UPDATE -> ()
        | VOICE_STATE_UPDATE -> ()
        | RESUME -> ()
        | RECONNECT -> ()
        | REQUEST_GUILD_MEMBERS -> ()
        | INVALID_SESSION -> ()
        | HELLO -> ()
        | HEARTBEAT_ACK -> ()
        |> ignore;
        (* { shard with seq = s; } *)
    end
    | _ -> shard

let wrap_payload d op =
    `Assoc [
        ("op", `Int op);
        ("d", d)
    ]

let create_frame content =
    Frame.create ~content ()

let identify ?(threshold=250) shard=
    let p = wrap_payload (`Assoc [
        ("token", `String shard.token);
        ("properties", `Assoc [
            ("$os", `String Sys.os_type);
            ("$browser", `String "animus");
            ("$device", `String "animus");
        ]);
        ("large_threshold", `Int threshold);
        ("shard", `List [`Int shard.id; `Int shard.total_shards]);
    ]) (Opcode.to_int IDENTIFY) in
    push_frame shard (Yojson.Basic.to_string p |> create_frame)

let resume shard =
    let p = wrap_payload (`Assoc [
        ("token", `String shard.token);
        ("session_id", `String shard.session_id);
        ("seq", `Int shard.seq);
    ]) (Opcode.to_int RESUME) in
    push_frame shard (Yojson.Basic.to_string p |> create_frame)

let heartbeat shard =
    let p = wrap_payload (`Int shard.seq) (Opcode.to_int HEARTBEAT) in
    push_frame shard (Yojson.Basic.to_string p |> create_frame)

let connect ~_options ~uri ~id ~total ~token () =
    let url = uri |> Uri.to_string in
    let ip = Ipaddr.V4 Ipaddr.V4.any in
    let client = Websocket.Connected_Client.create
    Websocket_lwt.with_connection (`TLS (`Hostname url, `IP ip, `Port 443)) uri (* Maybe use upgrade_connection? *)
    >|= fun (recv, send) ->
    init ~send ~id ~token ~total_shards:total ()