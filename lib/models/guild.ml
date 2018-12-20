module Make(Http : S.Http) = struct
    open Core
    open Async
    open Guild_t

    type t = Guild_t.t

    let ban_user ~id ?(reason="") ?(days=0) guild =
        Http.guild_ban_add guild.id id (`Assoc [
            ("delete-message-days", `Int days);
            ("reason", `String reason);
        ]) >>| Result.map ~f:ignore

    let create_emoji ~name ~image guild =
        Http.create_emoji guild.id (`Assoc [
            ("name", `String name);
            ("image", `String image);
            ("roles", `List []);
        ]) >>| Result.map ~f:Emoji_j.t_of_string

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
         >>| Result.map ~f:(fun r ->
            Role_j.role_of_string r 
            |> Event.wrap_role ~guild_id:guild.id)
    
    let create_channel ~mode ~name guild =
        let kind = match mode with
        | `Text -> 0
        | `Voice -> 2
        | `Category -> 4
        in Http.create_guild_channel guild.id (`Assoc [
            ("name", `String name);
            ("type", `Int kind);
        ]) >>| Result.map ~f:Channel_j.t_of_string
    
    let delete guild = 
        Http.delete_guild guild.id >>| Result.map ~f:ignore

    let get_ban ~id guild =
        Http.get_ban guild.id id >>| Result.map ~f:Ban_j.t_of_string
    
    let get_bans guild =
        Http.get_bans guild.id >>| Result.map ~f:(fun bans ->
            Yojson.Safe.from_string bans
            |> Yojson.Safe.Util.to_list
            |> List.map ~f:(fun ban ->
                Yojson.Safe.to_string ban
                |> Ban_j.t_of_string))

    let get_channel ~id guild =
        match List.find ~f:(fun c -> c.id = id) guild.channels with
        | Some c -> Channel_j.(string_of_channel_wrapper c |> t_of_string) |> Deferred.Or_error.return
        | None -> Http.get_channel id >>| Result.map ~f:Event.wrap_channel
    
    let get_emoji ~id guild =
        Http.get_emoji guild.id id >>| Result.map ~f:Emoji_j.t_of_string

    (* TODO add invite abstraction? *)
    let get_invites guild =
        Http.get_guild_invites guild.id

    let get_member ~id guild =
        match List.find ~f:(fun m -> m.user.id = id) guild.members with
        | Some m -> Deferred.Or_error.return m
        | None -> Http.get_member guild.id id >>| Result.map ~f:Member_j.member_of_string

    let get_prune_count ~days guild =
        Http.guild_prune_count guild.id days >>| Result.map ~f:(fun prune ->
            Yojson.Safe.(from_string prune
            |> Util.member "pruned"
            |> Util.to_int))

    (* TODO add HTTP fallback *)
    let get_role ~id guild =
        let role = List.find ~f:(fun r -> r.id = id) guild.roles in
        Option.(role >>| Event.wrap_role ~guild_id:guild.id)
    
    (* TODO add webhook abstraction? *)
    let get_webhooks guild =
        Http.get_guild_webhooks guild.id

    let kick_user ~id ?reason guild =
        let payload = match reason with
        | Some r -> `Assoc [("reason", `String r)]
        | None -> `Null
        in Http.remove_member guild.id id payload >>| Result.map ~f:ignore

    let leave guild =
        Http.leave_guild guild.id

    (* TODO Voice region abstractions? *)
    let list_voice_regions guild =
        Http.get_guild_voice_regions guild.id

    let prune ~days guild =
        Http.guild_prune_start guild.id days >>| Result.map ~f:(fun prune ->
            Yojson.Safe.(from_string prune
            |> Util.member "pruned"
            |> Util.to_int))
    
    let request_members guild =
        Http.get_members guild.id >>| Result.map ~f:(fun members ->
            Yojson.Safe.from_string members
            |> Yojson.Safe.Util.to_list
            |> List.map ~f:(fun ban ->
                Yojson.Safe.to_string ban
                |> Member_j.t_of_string))

    let set_afk_channel ~id guild = Http.edit_guild guild.id (`Assoc [
        ("afk_channel_id", `Int id);
    ]) >>| Result.map ~f:Guild_j.t_of_string

    let set_afk_timeout ~timeout guild = Http.edit_guild guild.id (`Assoc [
        ("afk_timeout", `Int timeout);
    ]) >>| Result.map ~f:Guild_j.t_of_string

    let set_name ~name guild = Http.edit_guild guild.id (`Assoc [
        ("name", `String name);
    ]) >>| Result.map ~f:Guild_j.t_of_string

    let set_icon ~icon guild = Http.edit_guild guild.id (`Assoc [
        ("icon", `String icon);
    ]) >>| Result.map ~f:Guild_j.t_of_string

    let unban_user ~id ?reason guild =
        let payload = match reason with
        | Some r -> `Assoc [("reason", `String r)]
        | None -> `Null
        in Http.guild_ban_remove guild.id id payload >>| Result.map ~f:ignore
end