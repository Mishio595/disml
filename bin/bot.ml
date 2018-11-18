open Async
open Core
open Disml

let main () =
    let token = match Sys.getenv "DISCORD_TOKEN" with
    | Some s -> s
    | None -> failwith "No token"
    in
    let client = Client.make token in
    Client.on "MESSAGE_CREATE" client (fun msg ->
        let msg_time = Time.(to_span_since_epoch @@ now ()) in
        let content = Yojson.Basic.Util.(member "content" msg |> to_string) in
        let channel = Yojson.Basic.Util.(member "channel_id" msg |> to_string) in
        if String.is_prefix ~prefix:"!?ping" content then
            Http.create_message channel @@ `Assoc [
                ("content", `String "Pong!");
                ("tts", `Bool false);
            ]
            >>> fun resp ->
            let message_id = Yojson.Basic.Util.(member "id" resp |> to_string) in
            let rtt = Time.(to_span_since_epoch @@ sub (now ()) msg_time) in
            Http.edit_message channel message_id @@ `Assoc [
                ("content", `String ("Pong! `" ^ (Float.to_string @@ Time.Span.to_ms rtt) ^ " ms`"));
            ]
            >>> fun _ -> print_endline "Message Edited!"
    );
    Client.start client
    >>> fun client ->
    Clock.every
    (Time.Span.create ~sec:60 ())
    (fun () ->
        Client.set_status_with client (fun shard -> `String ("Current seq: " ^ (Int.to_string shard.seq)))
        |> ignore)

let _ =
    Scheduler.go_main ~main ()