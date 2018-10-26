type t = {
    conn = Conn.t;
    id: int;
    hb_interval: int;
    session_id: string;
    seq: int;
}

let init ?(hb_interval=42500) ?(session_id="") ?(seq=0) ~conn ~id () =
    { conn; id; hb_interval; session_id; seq; }

let compare s1 s2 =
    Pervasives.compare s1.id s2.id

let push_frame ~payload shard =
    payload
    |> Conn.push_frame ~conn:shard.conn

let process_frame ~frame shard = 
    let json = frame |> Yojson.Basic.from_string in
    match json with
    | `Assoc [("s", s); ("d", d); ("t", t); ("op", op);] -> begin
        match op |> Opcode.from_int with
        | DISPATCH -> dispatch t d (* Need to write the dispatcher and other ops *)
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
        { shard with seq = s; }
        end
    | _ -> shard

let wrap_payload d op =
    `Assoc [
        ("op", `Int op);
        ("d", d)
    ]

let create_frame content =
    Frame.create ~content ()

let identify ?(threshold=250) ~total ~token shard =
    let p = wrap_payload (`Assoc [
        ("token", `String token);
        ("properties", `Assoc [
            ("$os", `String Sys.os_type);
            ("$browser", `String "animus");
            ("$device", `String "animus");
        ]);
        ("large_threshold", `Int threshold);
        ("shard", `List [`Int shard.id; `Int total]);
    ]) (IDENTIFY |> Opcode.to_int) in
    push_frame ~frame:(Yojson.Basic.to_string p |> create_frame) shard

let resume ~token shard =
    let p = wrap_payload (`Assoc [
        ("token", `String token);
        ("session_id", `String shard.session_id);
        ("seq", `Int shard.seq);
    ]) (RESUME |> Opcode.to_int) in
    push_frame ~frame:(Yojson.Basic.to_string p |> create_frame) shard

let heartbeat shard =
    let p = wrap_payload (`Int shard.seq) (HEARTBEAT |> Opcode.to_int) in
    push_frame ~frame:(Yojson.Basic.to_string p |> create_frame) shard

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
    shard