open Lwt.Infix
open Animus

let main sharder =
    Lwt_engine.on_timer 60.0 true begin
        fun _ev -> Sharder.set_status sharder @@ `String "Testing..."
        >|= (fun _ -> print_endline "Status set!")
        |> ignore;
    end

let _ =
    Animus.Sharder.start @@ Sys.getenv "DISCORD_TOKEN"
    >>= (fun sharder ->
    main sharder
    |> ignore;
    Lwt_main.run sharder.promise)
    |> Lwt_main.run