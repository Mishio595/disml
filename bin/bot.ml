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
        let content = Yojson.Basic.Util.(member "content" msg |> to_string) in
        let channel = Yojson.Basic.Util.(member "channel_id" msg |> to_string) in
        if String.is_prefix ~prefix:"!?ping" content then
            Http.create_message channel @@ `Assoc [
                ("content", `String "Pong!");
                ("tts", `Bool false);
            ]
            >>> fun _ -> print_endline "Message sent!";
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