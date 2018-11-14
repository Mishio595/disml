open Lwt.Infix
open Disml

let main sharder =
    Lwt_engine.on_timer 60.0 true begin
        fun _ev -> Sharder.set_status_with sharder @@ begin
        fun shard ->
            `String ("Current seq: " ^ string_of_int shard.seq)
        end
        >|= (fun _ -> print_endline "Status set!")
        |> ignore;
    end

let _ =
    Sharder.start @@ Sys.getenv "DISCORD_TOKEN"
    >>= (fun sharder ->
    main sharder
    |> ignore;
    sharder.promise)
    |> Lwt_main.run