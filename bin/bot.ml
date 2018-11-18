open Async
open Disml

let main () =
    let token = match Sys.getenv "DISCORD_TOKEN" with
    | Some s -> s
    | None -> failwith "No token"
    in
    Sharder.start token
    |> ignore

let _ =
    Scheduler.go_main ~main:(main) ()