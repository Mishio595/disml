open Async
open Core

module Client = Disml.Client.Make(struct
    let token = match Sys.getenv "DISCORD_TOKEN" with
    | Some t -> t
    | None -> failwith "No token in env"
end)(Handler)

let main () =
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
