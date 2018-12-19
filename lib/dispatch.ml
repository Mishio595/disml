module Make(H : S.Handler) : S.Dispatch = struct
    let dispatch ~ev contents =
        Printf.printf "Dispatching %s\n%!" ev;
        (* print_endline (Yojson.Safe.prettify contents); *)
        Event.event_of_string ~contents ev
        |> H.handle_event
end