open Async
open Core
open Disml

let main () =
    let token = match Sys.getenv "DISCORD_TOKEN" with
    | Some t -> t
    | None -> failwith "No token in env"
    in
    Client.start token
    >>> ignore

let _ =
    Client.message_create := (fun msg -> print_endline msg.content);
    Scheduler.go_main ~main ()
