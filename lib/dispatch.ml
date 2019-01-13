module Make(H : sig val handle_event : Event.t -> unit end) : S.Dispatch = struct
    let dispatch ~ev contents =
        (* Printf.printf "Dispatching %s\n%!" ev; *)
        (* print_endline (Yojson.Safe.prettify contents); *)
        try
            Event.event_of_yojson ~contents ev
            |> H.handle_event
        with Event.Invalid_event ev -> Printf.printf "Unknown event: %s%!" ev
end