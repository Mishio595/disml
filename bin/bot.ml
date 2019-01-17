open Async
open Core
open Disml

let check_command (msg:Message.t) =
    if String.is_prefix ~prefix:"!ping" msg.content then
        Message.reply msg "Pong!" >>> ignore
    else if String.is_prefix ~prefix:"!spam" msg.content then
        let count = String.chop_prefix_exn ~prefix:"!spam" msg.content |> String.strip |> Int.of_string in
        List.range 0 count
        |> List.iter ~f:(fun i -> Message.reply msg (string_of_int i) >>> ignore)
    else if String.is_prefix ~prefix:"!list" msg.content then
        let count = String.chop_prefix_exn ~prefix:"!list" msg.content |> String.strip |> Int.of_string in
        let list = List.range 0 count
        |> List.sexp_of_t Int.sexp_of_t
        |> Sexp.to_string_hum in
        Message.reply msg list >>> ignore
    else if String.is_prefix ~prefix:"!fold" msg.content then
        let count = String.chop_prefix_exn ~prefix:"!fold" msg.content |> String.strip |> Int.of_string in
        let list = List.range 0 count
        |> List.fold ~init:0 ~f:(+)
        |> Int.to_string in
        Message.reply msg list >>> ignore

let main () =
    let token = match Sys.getenv "DISCORD_TOKEN" with
    | Some t -> t
    | None -> failwith "No token in env"
    in
    Client.start token
    >>> ignore

let _ =
    Client.message_create := check_command;
    Scheduler.go_main ~main ()
