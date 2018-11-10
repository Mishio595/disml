open Lwt.Infix
open Animus

let _ =
    let data = Lwt_main.run (Http.get_gateway_bot ()) in
    (* Yojson.Basic.pretty_print Format.std_formatter data;
    print_newline (); *)
    let url, _shards = match data with
    | `Assoc [
        ("url", `String url);
        ("shards", `Int shards);
        _
    ] -> (url, shards)
    | _ -> ("wss://gateway.discord.gg/", 1)
    in
    (Sharder.Shard.create {
        url;
        shards = [0; 1;];
        token = Sys.getenv "DISCORD_TOKEN";
    }
    >|= fun (shard, recv_loop) ->
    Lwt_engine.on_timer 60.0 true @@ begin
    fun _ev -> Sharder.Shard.set_status shard
    ("Current seq: " ^ string_of_int shard.seq)
    >|= (fun _ -> print_endline "Status set!")
    |> ignore;
    end
    |> ignore;
    Lwt_main.run recv_loop)
    |> Lwt_main.run