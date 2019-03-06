open Lwt.Infix
open Disml
open Models

module Option = Base.Option
module Error = Base.Error
module List = Base.List
module Int = Base.Int

(* Client object will be stored here after creation. *)
let client, r_client = Lwt.wait ()

(* Example ping command with REST round trip time edited into the response. *)
let ping message _args =
    Message.reply message "Pong!" >>= function
    | Ok message' ->
        let `Message_id t, `Message_id t' = message.id, message'.id in
        let time = Snowflake.(timestamp t' - timestamp t) |> abs in
        Message.set_content message' (Printf.sprintf "Pong! `%d ms`" time)
        >|= ignore
    | Error e -> Error.(of_string e |> raise)

(* Send a list of consecutive integers of N size with 1 message per list item. *)
let spam message args =
    let count = Option.((List.hd args >>| Int.of_string) |> value ~default:0) in
    List.range 0 count
    |> List.iter ~f:(fun i -> Lwt.async (fun () -> Message.reply message (string_of_int i)))
    |> Lwt.return

(* Send a list of consecutive integers of N size in a single message. *)
let list message args =
    let count = Option.((List.hd args >>| Int.of_string) |> value ~default:0) in
    let list = List.range 0 count
    |> List.sexp_of_t Int.sexp_of_t
    |> Sexplib.Sexp.to_string_hum in
    Message.reply message list >|= function
    | Ok msg -> print_endline msg.content
    | Error err -> print_endline err

(* Example of setting pretty much everything in an embed using the Embed module builders *)
let embed message _args =
    let image_url = "https://cdn.discordapp.com/avatars/345316276098433025/17ccdc992814cc6e21a9e7d743a30e37.png" in
    let embed = Embed.(default
        |> title "Foo"
        |> description "Bar"
        |> url "https://gitlab.com/Mishio595/disml"
        (* |> timestamp Time.(now () |> to_string_iso8601_basic ~zone:Time.Zone.utc) *)
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
    Message.reply_with ~embed message >|= ignore

(* Set the status of all shards to a given string. *)
let status message args =
    let name = List.fold ~init:"" ~f:(fun a v -> a ^ " " ^ v) args in
    client >>= fun client ->
    Client.set_status ~name client
    >>= fun _ ->
    Message.reply message "Updated status" >|= ignore

(* Fetches a message by ID in the current channel, defaulting to the sent message, and prints in s-expr form. *)
let echo (message:Message.t) args =
    let `Message_id id = message.id in
    let id = Option.((List.hd args >>| Int.of_string) |> value ~default:id) in
    Channel_id.get_message ~id message.channel_id >>= function
    | Ok msg ->
        let str = Message.sexp_of_t msg |> Sexplib.Sexp.to_string_hum in
        Message.reply message (Printf.sprintf "```lisp\n%s```" str) >|= ignore
    | _ -> Lwt.return_unit

(* Output cache counts as a a basic embed. *)
let cache message _args =
    let module C = Cache.ChannelMap in
    let module G = Cache.GuildMap in
    let module U = Cache.UserMap in
    Cache.read_copy Cache.cache >>= fun cache ->
    let gc = G.cardinal cache.guilds in
    let ug = G.cardinal cache.unavailable_guilds in
    let tc = C.cardinal cache.text_channels in
    let vc = C.cardinal cache.voice_channels in
    let cs = C.cardinal cache.categories in
    let gr = C.cardinal cache.groups in
    let pr = C.cardinal cache.private_channels in
    let uc = U.cardinal cache.users in
    let pre = U.cardinal cache.presences in
    let user = Option.(value ~default:"None" (map cache.user ~f:User.tag)) in
    let embed = Embed.(default
        |> description (Printf.sprintf
            "Guilds: %d\nUnavailable Guilds: %d\n\
            Text Channels: %d\nVoice Channels: %d\n\
            Categories: %d\nGroups: %d\n\
            Private Channels: %d\nUsers: %d\n\
            Presences: %d\nCurrent User: %s"
            gc ug tc vc cs gr pr uc pre user)) in
    Message.reply_with ~embed message >|= ignore

(* Issue a shutdown to all shards, then exits the process. *)
let shutdown (message:Message.t) _args =
    if message.author.id = `User_id 242675474927583232 then
        client >>= Client.shutdown_all ~restart:false >|= fun _ ->
        exit 0
    else Lwt.return_unit

let restart (message:Message.t) _args =
    if message.author.id = `User_id 242675474927583232 then
        client >>= Client.shutdown_all
    else Lwt.return_unit

(* Request guild members to be sent over the gateway for the guild the command is run in. This will cause multiple GUILD_MEMBERS_CHUNK events. *)
let request_members (message:Message.t) _args =
    client >>= fun client ->
    match message.guild_id with
    | Some guild -> Client.request_guild_members ~guild client >|= ignore
    | None -> Lwt.return_unit

(* Creates a guild named testing or what the user provided *)
let new_guild message args =
    let name = List.fold ~init:"" ~f:(fun a v -> a ^ " " ^ v) args in
    let name = if String.length name = 0 then "Testing" else name in
    Guild.create [ "name", `String name ] >>= begin function
    | Ok g -> Message.reply message (Printf.sprintf "Created guild %s" g.name)
    | Error e -> Message.reply message (Printf.sprintf "Failed to create guild. Error: %s" e)
    end >|= ignore

(* Deletes all guilds made by the bot *)
let delete_guilds message _args =
    Cache.read_copy Cache.cache >>= fun cache ->
    let uid = match cache.user with
    | Some u -> u.id
    | None -> `User_id 0
    in
    let guilds = Cache.GuildMap.filter (fun _ (g:Guild.t) -> g.owner_id = uid) cache.guilds in
    let res = ref "" in
    let all = Cache.GuildMap.(map (fun g -> Guild.delete g >|= function
    | Ok () -> res := Printf.sprintf "%s\nDeleted %s" !res g.name
    | Error _ -> ()) guilds |> to_seq) |> Seq.map snd |> Stdlib.List.of_seq in
    Lwt.join all >>= (fun _ ->
    Message.reply message !res) >|= ignore

let role_test (message:Message.t) args =
    let exception Member_not_found in
    Cache.read_copy Cache.cache >>= fun cache ->
    let name = List.fold ~init:"" ~f:(fun a v -> a ^ " " ^ v) args in
    let create_role name guild_id =
        Guild_id.create_role ~name guild_id >|= function
        | Ok role -> role
        | Error e -> raise (Failure e)
    in
    let delete_role role =
        Role.delete role >|= function
        | Ok () -> ()
        | Error e -> raise (Failure e)
    in
    let add_role member role =
        Member.add_role ~role member >|= function
        | Ok () -> role
        | Error e -> raise (Failure e)
    in
    let remove_role member role =
        Member.remove_role ~role member >|= function
        | Ok () -> role
        | Error e -> raise (Failure e)
    in
    let get_member id = match Cache.GuildMap.find_opt id cache.guilds with
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
        end >|= ignore
    | None -> Lwt.return_unit

let check_permissions (message:Message.t) _args =
    Cache.read_copy Cache.cache >>= fun cache ->
    let empty = Permissions.empty in
    let permissions = match message.guild_id, message.member with
    | Some g, Some m ->
        begin match Cache.guild g cache with
        | Some g ->
            List.fold m.roles ~init:Permissions.empty ~f:(fun acc rid ->
                let role = List.find_exn g.roles ~f:(fun r -> r.id = rid) in
                Permissions.union acc role.permissions)
        | None -> empty
        end
    | _ -> empty in
    let allow, deny = match message.member with
    | Some m ->
        begin match Cache.text_channel message.channel_id cache with
        | Some c ->
            List.fold c.permission_overwrites ~init:(empty, empty) ~f:(fun (a,d) {allow; deny; id; kind} ->
                let `User_id uid = message.author.id in
                if (kind = "role" && List.mem m.roles (`Role_id id) ~equal:(=)) || (kind = "user" && id = uid) then
                    Permissions.union allow a, Permissions.union deny d
                else a, d
            )
        | None -> empty, empty
        end
    | None -> empty, empty in
    let g_perms = Permissions.elements permissions
        |> List.sexp_of_t Permissions.sexp_of_elt
        |> Sexplib.Sexp.to_string_hum in
    let c_perms = Permissions.(union permissions allow
        |> diff deny
        |> elements)
        |> List.sexp_of_t Permissions.sexp_of_elt
        |> Sexplib.Sexp.to_string_hum in
    Message.reply message (Printf.sprintf "Global Permissions: %s\nChannel Permissions: %s" g_perms c_perms) >|= ignore