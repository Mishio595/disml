open Async
open Core
open Disml
open Models

(* Client object will be stored here after creation. *)
let client = Ivar.create ()

(* Example ping command with REST round trip time edited into the response. *)
let ping message _args =
    Message.reply message "Pong!" >>> function
    | Ok message ->
        let diff = Time.diff (Time.now ()) (Time.of_string message.timestamp) in
        Message.set_content message (Printf.sprintf "Pong! `%d ms`" (Time.Span.to_ms diff |> Float.abs |> Float.to_int)) >>> ignore
    | Error e -> Error.raise e

(* Send a list of consecutive integers of N size with 1 message per list item. *)
let spam message args =
    let count = Option.((List.hd args >>| Int.of_string) |> value ~default:0) in
    List.range 0 count
    |> List.iter ~f:(fun i -> Message.reply message (string_of_int i) >>> ignore)

(* Send a list of consecutive integers of N size in a single message. *)
let list message args =
    let count = Option.((List.hd args >>| Int.of_string) |> value ~default:0) in
    let list = List.range 0 count
    |> List.sexp_of_t Int.sexp_of_t
    |> Sexp.to_string_hum in
    Message.reply message list >>> function
    | Ok msg -> print_endline msg.content
    | Error err -> print_endline (Error.to_string_hum err)

(* Example of setting pretty much everything in an embed using the Embed module builders *)
let embed message _args =
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

(* Set the status of all shards to a given string. *)
let status message args =
    let name = List.fold ~init:"" ~f:(fun a v -> a ^ " " ^ v) args in
    Ivar.read client >>> fun client ->
    Client.set_status ~name client
    >>> fun _ ->
    Message.reply message "Updated status" >>> ignore

(* Fetches a message by ID in the current channel, defaulting to the sent message, and prints in s-expr form. *)
let echo (message:Message.t) args =
    let `Message_id id = message.id in
    let id = Option.((List.hd args >>| Int.of_string) |> value ~default:id) in
    Channel_id.get_message ~id message.channel_id >>> function
    | Ok msg ->
        let str = Message.sexp_of_t msg |> Sexp.to_string_hum in
        print_endline str;
        Message.reply message (Printf.sprintf "```lisp\n%s```" str) >>> ignore
    | _ -> ()

(* Output cache counts as a a basic embed. *)
let cache message _args =
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
        |> description (Printf.sprintf
            "Guilds: %d\nText Channels: %d\n\
            Voice Channels: %d\nCategories: %d\n\
            Groups: %d\nPrivate Channels: %d\n\
            Users: %d\nPresences: %d\n\
            Current User: %s"
            gc tc vc cs gr pr uc pre user)) in
    Message.reply_with ~embed message >>> ignore

(* Issue a shutdown to all shards, then exits the process. *)
let shutdown _message _args =
    Ivar.read client >>= Client.shutdown_all ~restart:false >>> fun _ ->
    exit 0

(* Request guild members to be sent over the gateway for the guild the command is run in. This will cause multiple GUILD_MEMBERS_CHUNK events. *)
let request_members (message:Message.t) _args =
    Ivar.read client >>> fun client ->
    match message.guild_id with
    | Some guild -> Client.request_guild_members ~guild client >>> ignore
    | None -> ()

(* Creates a guild named testing or what the user provided *)
let new_guild message args =
    let name = List.fold ~init:"" ~f:(fun a v -> a ^ " " ^ v) args in
    let name = if String.length name = 0 then "Testing" else name in
    Guild.create [ "name", `String name ] >>= begin function
    | Ok g -> Message.reply message (Printf.sprintf "Created guild %s" g.name)
    | Error e -> Message.reply message (Printf.sprintf "Failed to create guild. Error: %s" (Error.to_string_hum e))
    end >>> ignore

(* Deletes all guilds made by the bot *)
let delete_guilds message _args =
    let cache = Mvar.peek_exn Cache.cache in
    let uid = match cache.user with
    | Some u -> u.id
    | None -> `User_id 0
    in
    let guilds = Cache.GuildMap.filter cache.guilds ~f:(fun g -> g.owner_id = uid) in
    let res = ref "" in
    let all = Cache.GuildMap.(map guilds ~f:(fun g -> Guild.delete g >>| function
    | Ok () -> res := Printf.sprintf "%s\nDeleted %s" !res g.name
    | Error _ -> ()) |> to_alist) |> List.map ~f:(snd) in
    Deferred.all all >>= (fun _ ->
    Message.reply message !res) >>> ignore

let role_test (message:Message.t) args =
    let exception Member_not_found in
    let cache = Mvar.peek_exn Cache.cache in
    let name = List.fold ~init:"" ~f:(fun a v -> a ^ " " ^ v) args in
    let create_role name guild_id =
        Guild_id.create_role ~name guild_id >>| function
        | Ok role -> role
        | Error e -> Error.raise e
    in
    let delete_role role =
        Role.delete role >>| function
        | Ok () -> ()
        | Error e -> Error.raise e
    in
    let add_role member role =
        Member.add_role ~role member >>| function
        | Ok () -> role
        | Error e -> Error.raise e
    in
    let remove_role member role =
        Member.remove_role ~role member >>| function
        | Ok () -> role
        | Error e -> Error.raise e
    in
    let get_member id = match Cache.GuildMap.find cache.guilds id with
        | Some guild ->
            begin match List.find guild.members ~f:(fun m -> m.user.id = message.author.id) with
            | Some member -> member
            | None -> raise Member_not_found
            end
        | None -> raise Member_not_found
    in
    match message.guild_id with
    | Some id -> begin try
        let member = get_member id in
        create_role name id
        >>= add_role member
        >>= remove_role member
        >>= delete_role
        >>= (fun () -> Message.reply message "Role test finished")
        with
        | Member_not_found -> Message.reply message "Error: Member not found"
        | exn -> Message.reply message (Printf.sprintf "Error: %s" Error.(of_exn exn |> to_string_hum))
        end >>> ignore
    | None -> ()