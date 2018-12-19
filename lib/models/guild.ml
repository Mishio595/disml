module Make(Http : S.Http) = struct
    open Core
    open Async
    open Guild_t

    type t = Guild_t.t

    let ban_user ~id ?(reason="") ?(days=0) guild =
        Http.guild_ban_add guild.id id (`Assoc [
            ("delete-message-days", `Int days);
            ("reason", `String reason);
        ])

    let create_emoji ~name ~image guild =
        Http.create_emoji guild.id (`Assoc [
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
        in Http.guild_role_add guild.id (`Assoc payload)
    
    let create_channel ~mode ~name guild =
        let kind = match mode with
        | `Text -> 0
        | `Voice -> 2
        | `Category -> 4
        in Http.create_guild_channel guild.id (`Assoc [
            ("name", `String name);
            ("type", `Int kind);
        ])
    
    let delete guild = Http.delete_guild guild.id
    let get_ban ~id guild = Http.get_ban guild.id id
    let get_bans guild = Http.get_bans guild.id

    let get_channel ~id guild =
        match List.find ~f:(fun c -> c.id = id) guild.channels with
        | Some c -> Deferred.Or_error.return c
        | None -> Http.get_channel id >>| fun c ->
            Result.(c >>| Channel_j.t_of_string)
    
    let get_emoji ~id guild = Http.get_emoji guild.id id
    let get_invites guild = Http.get_guild_invites guild.id

    let get_member ~id guild =
        match List.find ~f:(fun m -> m.user.id = id) guild.members with
        | Some m -> Deferred.Or_error.return m
        | None -> Http.get_member guild.id id >>| fun m ->
             Result.(m >>| Member_j.t_of_string)

    let get_prune_count ~days guild = Http.guild_prune_count guild.id days

    let get_role ~id guild =
        let role = List.find ~f:(fun r -> r.id = id) guild.roles in
        Option.(role >>| fun role -> Event.wrap_role { role; id=guild.id; })
    
    let get_webhooks guild = Http.get_guild_webhooks guild.id

    let kick_user ~id ?reason guild =
        let payload = match reason with
        | Some r -> `Assoc [("reason", `String r)]
        | None -> `Null
        in Http.remove_member guild.id id payload

    let leave guild = Http.leave_guild guild.id
    let list_voice_regions guild = Http.get_guild_voice_regions guild.id
    let prune ~days guild = Http.guild_prune_start guild.id days
    let request_members guild = Http.get_members guild.id

    let set_afk_channel ~id guild = Http.edit_guild guild.id (`Assoc [
        ("afk_channel_id", `Int id);
    ])

    let set_afk_timeout ~timeout guild = Http.edit_guild guild.id (`Assoc [
        ("afk_timeout", `Int timeout);
    ])

    let set_name ~name guild = Http.edit_guild guild.id (`Assoc [
        ("name", `String name);
    ])

    let set_icon ~icon guild = Http.edit_guild guild.id (`Assoc [
        ("icon", `String icon);
    ])

    let unban_user ~id ?reason guild =
        let payload = match reason with
        | Some r -> `Assoc [("reason", `String r)]
        | None -> `Null
        in Http.guild_ban_remove guild.id id payload
end