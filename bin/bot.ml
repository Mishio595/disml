open Async
open Core
open Disml

let check_command (msg:Message.t) =
    let cmd, rest = match String.split ~on:' ' msg.content with
    | hd::tl -> hd, tl
    | [] -> "", []
    in match cmd with
    | "!ping" ->
        Message.reply msg "Pong!" >>> ignore
    | "spam" ->
        let count = Option.((List.hd rest >>| Int.of_string) |> value ~default:0) in
        List.range 0 count
        |> List.iter ~f:(fun i -> Message.reply msg (string_of_int i) >>> ignore)
    | "!list" ->
        let count = Option.((List.hd rest >>| Int.of_string) |> value ~default:0) in
        let list = List.range 0 count
        |> List.sexp_of_t Int.sexp_of_t
        |> Sexp.to_string_hum in
        Message.reply msg list >>> ignore
    | "!fold" ->
        let count = Option.((List.hd rest >>| Int.of_string) |> value ~default:0) in
        let list = List.range 0 count
        |> List.fold ~init:0 ~f:(+)
        |> Int.to_string in
        Message.reply msg list >>> ignore
    | _ -> ()

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
