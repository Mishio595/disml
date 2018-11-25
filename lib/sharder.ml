open Async
open Core
open Websocket_async

exception Invalid_Payload

module Shard = struct
    type t = {
        mutable hb: unit Ivar.t option;
        mutable seq: int;
        mutable session: string option;
        token: string;
        shard: int * int;
        write: string Pipe.Writer.t;
        read: string Pipe.Reader.t;
        ready: unit Ivar.t;
    }

    let identify_lock = Mutex.create ()

    let parse frame =
        match frame with
        | `Ok s -> Yojson.Basic.from_string s
        | `Eof -> raise Invalid_Payload (* This needs to go into reconnect code, or stop using client_ez and handle frames manually *)

    let push_frame ?payload shard ev =
        print_endline @@ "Pushing frame. OP: " ^ Opcode.to_string @@ ev;
        let content = match payload with
        | None -> ""
        | Some p ->
            Yojson.Basic.to_string @@ `Assoc [
            ("op", `Int (Opcode.to_int ev));
            ("d", p);
            ]
        in
        Pipe.write shard.write content
        >>| fun () ->
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

    let dispatch shard payload =
        let module J = Yojson.Basic.Util in
        let seq = J.(member "s" payload |> to_int) in
        shard.seq <- seq;
        let t = J.(member "t" payload |> to_string) in
        let data = J.member "d" payload in
        if t = "READY" then begin
            Ivar.fill_if_empty shard.ready ();
            let session = J.(member "session_id" data |> to_string) in
            shard.session <- Some session
        end;
        return shard

    let set_status shard status =
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
        push_frame ~payload shard STATUS_UPDATE

    let request_guild_members ~guild ?(query="") ?(limit=0) shard =
        let payload = `Assoc [
            ("guild_id", `String (string_of_int guild));
            ("query", `String query);
            ("limit", `Int limit);
        ] in
        Ivar.read shard.ready >>= fun _ ->
        push_frame ~payload shard REQUEST_GUILD_MEMBERS

    let initialize shard data =
        let module J = Yojson.Basic.Util in
        let hb = match shard.hb with
        | None -> begin
            let hb_interval = J.(member "heartbeat_interval" data |> to_int) in
            let finished = Ivar.create () in
            Clock.every'
            ~continue_on_error:true
            ~finished
            (Core.Time.Span.create ~ms:hb_interval ())
            (fun () -> heartbeat shard >>= fun _ -> return ());
            finished
        end
        | Some s -> s
        in
        shard.hb <- Some hb;
        Mutex.lock identify_lock;
        let (cur, max) = shard.shard in
        let shards = [`Int cur; `Int max] in
        match shard.session with
        | None ->
            let payload = `Assoc [
                ("token", `String shard.token);
                ("properties", `Assoc [
                    ("$os", `String Sys.os_type);
                    ("$device", `String "dis.ml");
                    ("$browser", `String "dis.ml")
                ]);
                ("compress", `Bool false); (* TODO add compression handling*)
                ("large_threshold", `Int 250);
                ("shard", `List shards);
            ] in
            push_frame ~payload shard IDENTIFY
        | Some s ->
            let payload = `Assoc [
                ("token", `String shard.token);
                ("session_id", `String s);
                ("seq", `Int shard.seq)
            ] in
            push_frame ~payload shard RESUME
        >>| fun s ->
        Clock.after (Core.Time.Span.create ~sec:5 ())
        >>| (fun _ -> Mutex.unlock identify_lock)
        |> ignore;
        s

    let handle_frame shard term =
        let module J = Yojson.Basic.Util in
        let op = J.(member "op" term |> to_int)
            |> Opcode.from_int
        in
        match op with
        | DISPATCH -> dispatch shard term
        | HEARTBEAT -> heartbeat shard
        | RECONNECT -> print_endline "OP 7"; return shard (* TODO reconnect *)
        | INVALID_SESSION -> print_endline "OP 9"; return shard (* TODO invalid session *)
        | HELLO -> initialize shard @@ J.member "d" term
        | HEARTBEAT_ACK -> return shard
        | opcode ->
            print_endline @@ "Invalid Opcode:" ^ Opcode.to_string opcode;
            return shard

    let create ~url ~shards ~token () =
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
        let tcp_fun (r,w) =
            let (read, write) = client_ez
                ~extra_headers
                uri r w
            in
            let rec ev_loop shard =
                Pipe.read read
                >>= fun frame ->
                handle_frame shard @@ parse frame
                >>= fun shard ->
                ev_loop shard
            in
            let shard = {
                read;
                write;
                ready = Ivar.create ();
                hb = None;
                seq = 0;
                shard = shards;
                session = None;
                token = token;
            }
            in
            ev_loop shard |> ignore;
            return shard
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
end

type t = {
    shards: Shard.t list;
}

let start ?count token =
    let module J = Yojson.Basic.Util in
    Http.get_gateway_bot () >>= fun data ->
    let url = J.(member "url" data |> to_string) in
    let count = match count with
    | Some c -> c
    | None -> J.(member "shards" data |> to_int)
    in
    let shard_list = (0, count) in
    let rec gen_shards l a =
        match l with
        | (id, total) when id >= total -> return a
        | (id, total) ->
            Shard.create ~url ~shards:(id, total) ~token ()
            >>= fun shard ->
            let a = shard :: a in
            gen_shards (id+1, total) a
    in
    gen_shards shard_list []
    >>| fun shards ->
    {
        shards;
    }

let set_status sharder status =
    Deferred.all @@ List.map ~f:(fun shard ->
        Shard.set_status shard status
    ) sharder.shards

let set_status_with sharder f =
    Deferred.all @@ List.map ~f:(fun shard ->
        Shard.set_status shard @@ f shard
    ) sharder.shards

let request_guild_members ~guild ?query ?limit sharder =
    Deferred.all @@ List.map ~f:(fun shard ->
        Shard.request_guild_members ~guild ?query ?limit shard
    ) sharder.shards
