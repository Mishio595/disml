open Async
open Core
open Disml

let main () =
    let token = match Sys.getenv "DISCORD_TOKEN" with
    | Some t -> t
    | None -> failwith "No token in env"
    in
    Client.create token;
    Client.start ()
    >>> fun client ->
    Clock.every
    (Time.Span.create ~sec:60 ())
    (fun () ->
        print_endline "Setting status";
        Client.set_status ~status:(`String "Hello!") client
        >>> ignore)

let _ =
    Scheduler.go_main ~main ()
