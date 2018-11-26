open Async
open Core
open Disml

(* let rec ev_loop read =
    Pipe.read read >>= fun frame ->
    match frame with
    | `Eof -> return ()
    | `Ok (t, data) -> begin
        match t with
        | "MESSAGE_CREATE" -> begin
            let msg = Model.to_message data in
            let msg_time = Time.(to_span_since_epoch @@ now ()) in
            let content = msg.content in
            let channel = msg.channel in
            if String.is_prefix ~prefix:"!?ping" content then begin
                Http.create_message channel @@ `Assoc [
                    ("content", `String "Pong!");
                    ("tts", `Bool false);
                ]
                >>> fun resp ->
                let message_id = Yojson.Basic.Util.(member "id" resp |> to_string) in
                let rtt = Time.(to_span_since_epoch @@ sub (now ()) msg_time) in
                Http.edit_message channel message_id @@ `Assoc [
                    ("content", `String ("Pong! `" ^ (Float.to_string @@ Time.Span.to_ms rtt) ^ " ms`"));
                ]
                >>> fun _ -> print_endline "Message Edited!"
            end;
            return ()
        end
        | "GUILD_CREATE" -> begin
            let guild = Model.to_guild data in
            print_endline guild.name;
            return ()
        end
        | _ -> return ()
    end
    >>= fun _ -> ev_loop read *)

let main () =
    let token = match Sys.getenv "DISCORD_TOKEN" with
    | Some s -> s
    | None -> failwith "No token"
    in
    let (_r,w) = Pipe.create () in
    let client = Client.create ~handler:w token in
    (* ev_loop r >>> ignore; *)
    Client.start client
    >>> fun client ->
    Clock.every
    (Time.Span.create ~sec:60 ())
    (fun () ->
        Client.set_status_with ~f:(fun shard -> `String ("Current seq: " ^ (Int.to_string shard.seq))) client
        |> ignore)

let _ =
    Scheduler.go_main ~main ()
