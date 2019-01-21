open Async
open Core
open Disml

let check_command (msg:Message.t) =
    let cmd, rest = match String.split ~on:' ' msg.content with
    | hd::tl -> hd, tl
    | [] -> "", []
    in match cmd with
    | "!ping" ->
        Message.reply msg "Pong!" >>= begin fun msg ->
        let msg = match msg with Ok m -> m | Error e -> Error.raise e in
        let diff = Time.diff (Time.now ()) (Time.of_string msg.timestamp) in
        Message.set_content msg (Printf.sprintf "Pong! `%d ms`" (Time.Span.to_ms diff |> Float.to_int))
        end >>> ignore
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
    | "!embed" ->
        let image_url = "https://images-ext-1.discordapp.net/external/46n5KQDNg1K4-UybFifnLsIVJkmIutfBG5zO_vpU5Zk/%3Fsize%3D1024/https/cdn.discordapp.com/avatars/345316276098433025/17ccdc992814cc6e21a9e7d743a30e37.webp" in
        let embed = Embed.(default
            |> title "Foo"
            |> description "Bar"
            |> url "https://gitlab.com/Mishio595/disml"
            |> timestamp Time.(now () |> to_string_iso8601_basic ~zone:Time.Zone.utc)
            |> colour 0xff
            |> footer { Embed.default_footer with text = "boop" }
            |> image { Embed.default_image with url = Some image_url }
            |> thumbnail { Embed.default_image with url = Some image_url }
            |> author { Embed.default_author with
                name = Some "Adelyn";
                url = Some "https://gitlab.com/Mishio595/disml";
                icon_url = Some image_url }
            |> field { name = "field 1"; value = "test"; inline = true; }
            |> field { name = "field 2"; value = "test"; inline = true; }
            |> field { name = "field 3"; value = "test"; inline = true; }
        ) in
        Message.reply_with ~embed msg >>> ignore
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
