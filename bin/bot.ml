open Async
open Core
open Disml

let client = Ivar.create ()

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
            |> footer (fun f -> footer_text "boop" f)
            |> image image_url
            |> thumbnail image_url
            |> author (fun a -> a
                |> author_name "Adelyn"
                |> author_icon image_url
                |> author_url "https://gitlab.com/Mishio595/disml")
            |> field ("field 3", "test", true)
            |> field ("field 2", "test", true)
            |> field ("field 1", "test", true)
        ) in
        Message.reply_with ~embed msg >>> ignore
    | "!status" ->
        let status = List.fold ~init:"" ~f:(fun a v -> a ^ " " ^ v) rest in
        Ivar.read client >>> fun client ->
        Client.set_status ~status:(`String status) client
        >>> fun _ ->
        Message.reply msg "Updated status" >>> ignore
    | "!test" ->
        let ch = `Channel_id 377716501446393856 in
        Channel_id.say "Testing..." ch >>> ignore
    | _ -> ()

let setup_logger () =
    Logs.set_reporter (Logs_fmt.reporter ());
    Logs.set_level ~all:true (Some Logs.Debug)

let main () =
    setup_logger ();
    Client.message_create := check_command;
    let token = match Sys.getenv "DISCORD_TOKEN" with
    | Some t -> t
    | None -> failwith "No token in env"
    in
    Client.start token
    >>> fun c ->
    Ivar.fill client c

let _ =
    Scheduler.go_main ~main ()
