open Core
open Async

include Guild_t

let ban_user ~id ?(reason="") ?(days=0) guild =
    Http.guild_ban_add (get_id guild) id (`Assoc [
        ("delete-message-days", `Int days);
        ("reason", `String reason);
    ])

let create_emoji ~name ~image guild =
    Http.create_emoji (get_id guild) (`Assoc [
        ("name", `String name);
        ("image", `String image);
        ("roles", `List []);
    ])

let create_role ~name ?colour ?permissions ?hoist ?mentionable guild =
    let payload = ("name", `String name) :: [] in
    let payload = match permissions with
    | Some p -> ("permissions", `Int p) :: payload
    | None -> payload
    in let payload = match colour with
    | Some c -> ("color", `Int c) :: payload
    | None -> payload
    in let payload = match hoist with
    | Some h -> ("hoist", `Bool h) :: payload
    | None -> payload
    in let payload = match mentionable with
    | Some m -> ("mentionable", `Bool m) :: payload
    | None -> payload
    in Http.guild_role_add (get_id guild) (`Assoc payload)

let create_channel ~mode ~name guild =
    let kind = match mode with
    | `Text -> 0
    | `Voice -> 2
    | `Category -> 4
    in Http.create_guild_channel (get_id guild) (`Assoc [
        ("name", `String name);
        ("type", `Int kind);
    ])

let delete guild = 
    Http.delete_guild (get_id guild)

let get_ban ~id guild =
    Http.get_ban (get_id guild) id

let get_bans guild =
    Http.get_bans (get_id guild)

let get_emoji ~id guild =
    Http.get_emoji (get_id guild) id

(* TODO add invite abstraction? *)
let get_invites guild =
    Http.get_guild_invites (get_id guild)

let get_prune_count ~days guild =
    Http.guild_prune_count (get_id guild) days

(* TODO add webhook abstraction? *)
let get_webhooks guild =
    Http.get_guild_webhooks (get_id guild)

let kick_user ~id ?reason guild =
    let payload = match reason with
    | Some r -> `Assoc [("reason", `String r)]
    | None -> `Null
    in Http.remove_member (get_id guild) id payload

let leave guild =
    Http.leave_guild (get_id guild)

(* TODO Voice region abstractions? *)
let list_voice_regions guild =
    Http.get_guild_voice_regions (get_id guild)

let prune ~days guild =
    Http.guild_prune_start (get_id guild) days

let request_members guild =
    Http.get_members (get_id guild)

let set_afk_channel ~id guild = Http.edit_guild (get_id guild) (`Assoc [
    ("afk_channel_id", `Int id);
    ])

let set_afk_timeout ~timeout guild = Http.edit_guild (get_id guild) (`Assoc [
    ("afk_timeout", `Int timeout);
    ])

let set_name ~name guild = Http.edit_guild (get_id guild) (`Assoc [
    ("name", `String name);
    ])

let set_icon ~icon guild = Http.edit_guild (get_id guild) (`Assoc [
    ("icon", `String icon);
    ])

let unban_user ~id ?reason guild =
    let payload = match reason with
    | Some r -> `Assoc [("reason", `String r)]
    | None -> `Null
    in Http.guild_ban_remove (get_id guild) id payload

let get_member ~(id:User_id_t.t) guild =
    match List.find ~f:(fun m -> m.user.id = id) guild.members with
    | Some m -> Deferred.Or_error.return m
    | None ->
        let `User_id id = id in
        Http.get_member (get_id guild) id

let get_channel ~(id:Channel_id_t.t) guild =
    let `Channel_id id = id in
    match List.find ~f:(fun c -> Channel_t.get_id c = id) guild.channels with
    | Some c -> Deferred.Or_error.return c
    | None -> Http.get_channel id

(* TODO add HTTP fallback *)
let get_role ~(id:Role_id.t) guild =
    List.find ~f:(fun r -> r.id = id) guild.roles