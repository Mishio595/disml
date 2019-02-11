open Async
open Core
open Disml
open Models

(* Client object will be stored here after creation. *)
let client = Ivar.create ()

(* Define a function to handle message_create *)
let check_command (message:Message.t) =
    (* Simple example of command parsing. *)
    let cmd, rest = match String.split ~on:' ' message.content with
    | hd::tl -> hd, tl
    | [] -> "", []
    in match cmd with
    | "!ping" -> (* Example ping command with REST round trip time edited into the response. *)
        Message.reply message "Pong!" >>> begin function
        | Ok message ->
            let diff = Time.diff (Time.now ()) (Time.of_string message.timestamp) in
            Message.set_content message (Printf.sprintf "Pong! `%d ms`" (Time.Span.to_ms diff |> Float.abs |> Float.to_int)) >>> ignore
        | Error e -> Error.raise e
        end
    | "!spam" -> (* Send a list of consecutive integers of N size with 1 message per list item. *)
        let count = Option.((List.hd rest >>| Int.of_string) |> value ~default:0) in
        List.range 0 count
        |> List.iter ~f:(fun i -> Message.reply message (string_of_int i) >>> ignore)
    | "!list" -> (* Send a list of consecutive integers of N size in a single message. *)
        let count = Option.((List.hd rest >>| Int.of_string) |> value ~default:0) in
        let list = List.range 0 count
        |> List.sexp_of_t Int.sexp_of_t
        |> Sexp.to_string_hum in
        Message.reply message list >>> begin function
        | Ok msg -> print_endline msg.content
        | Error err -> print_endline (Error.to_string_hum err)
        end
    | "!fold" -> (* Sum a consecutive list of integers of N size and send the result. *)
        let count = Option.((List.hd rest >>| Int.of_string) |> value ~default:0) in
        let list = List.range 0 count
        |> List.fold ~init:0 ~f:(+)
        |> Int.to_string in
        Message.reply message list >>> ignore
    | "!embed" -> (* Example of setting pretty much everything in an embed using the Embed module builders *)
        let image_url = "https://cdn.discordapp.com/avatars/345316276098433025/17ccdc992814cc6e21a9e7d743a30e37.png" in
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
        Message.reply_with ~embed message >>> ignore
    | "!status" -> (* Set the status of all shards to a given string. *)
        let status = List.fold ~init:"" ~f:(fun a v -> a ^ " " ^ v) rest in
        Ivar.read client >>> fun client ->
        Client.set_status ~status:(`String status) client
        >>> fun _ ->
        Message.reply message "Updated status" >>> ignore
    | "!test" -> (* Basic send message to channel ID, can use any ID as `Channel_id some_snowflake *)
        Channel_id.say "Testing..." message.channel_id >>> ignore
    | "!echo" -> (* Fetches a message by ID in the current channel, defaulting to the sent message, and prints in s-expr form. *)
        let `Message_id id = message.id in
        let id = Option.((List.hd rest >>| Int.of_string) |> value ~default:id) in
        Channel_id.get_message ~id message.channel_id >>> begin function
        | Ok msg -> Message.reply message (Printf.sprintf "```lisp\n%s```" (Message.sexp_of_t msg |> Sexp.to_string_hum)) >>> ignore
        | _ -> ()
        end
    | "!cache" -> (* Output cache counts as a a basic embed. *)
        let module C = Cache.ChannelMap in
        let module G = Cache.GuildMap in
        let module U = Cache.UserMap in
        let cache = Mvar.peek_exn Cache.cache in
        let gc = G.length cache.guilds in
        let tc = C.length cache.text_channels in
        let vc = C.length cache.voice_channels in
        let cs = C.length cache.categories in
        let gr = C.length cache.groups in
        let pr = C.length cache.private_channels in
        let uc = U.length cache.users in
        let pre = U.length cache.presences in
        let user = Option.(value ~default:"None" (cache.user >>| User.tag)) in
        let embed = Embed.(default
            |> description (Printf.sprintf "Guilds: %d\nText Channels: %d\nVoice Channels: %d\nCategories: %d\nGroups: %d\nPrivate Channels: %d\nUsers: %d\nPresences: %d\nCurrent User: %s" gc tc vc cs gr pr uc pre user)) in
        Message.reply_with ~embed message >>> ignore
    | "!shutdown" -> (* Issue a shutdown to all shards. It is expected that they will restart if `?restart` is not false. *)
        Ivar.read client >>> fun client ->
        Sharder.shutdown_all client.sharder >>> ignore
    | "!rgm" -> (* Request guild members to be sent over the gateway for the guild the command is run in. This will cause multiple GUILD_MEMBERS_CHUNK events. *)
        Ivar.read client >>> fun client ->
        (match message.guild_id with
        | Some guild -> Client.request_guild_members ~guild client >>> ignore
        | None -> ())
    | "!new" ->
        Guild.cr
    | _ -> () (* Fallback case, no matched command. *)

(* Example logs setup *)
let setup_logger () =
    Logs.set_reporter (Logs_fmt.reporter ());
    Logs.set_level ~all:true (Some Logs.Debug)

let main () =
    setup_logger ();
    (* Register some event handlers *)
    Client.message_create := check_command;
    Client.ready := (fun ready -> Logs.info (fun m -> m "Logged in as %s" (User.tag ready.user)));
    Client.guild_create := (fun guild -> Logs.info (fun m -> m "Joined guild %s" guild.name));
    (* Pull token from env var. It is not recommended to hardcore your token. *)
    let token = match Sys.getenv "DISCORD_TOKEN" with
    | Some t -> t
    | None -> failwith "No token in env"
    in
    (* Start client. *)
    Client.start ~large:250 ~compress:true token
    (* Fill that ivar once its done *)
    >>> Ivar.fill client

(* Lastly, we have to register this to the Async Scheduler for anything to work *)
let _ =
    Scheduler.go_main ~main ()
