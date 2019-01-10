module Make(Http : S.Http) = struct
    open Core
    open Async
    include Guild_t

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
        ]) >>| Result.map ~f:Emoji.of_yojson_exn

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
            >>| Result.map ~f:(fun r -> Role_t.role_of_yojson_exn r |> Role_t.wrap ~guild_id:guild.id)

    let create_channel ~mode ~name guild =
        let kind = match mode with
        | `Text -> 0
        | `Voice -> 2
        | `Category -> 4
        in Http.create_guild_channel guild.id (`Assoc [
            ("name", `String name);
            ("type", `Int kind);
        ]) >>| Result.map ~f:Channel_t.of_yojson_exn

    let delete guild = 
        Http.delete_guild guild.id >>| Result.map ~f:ignore

    let get_ban ~id guild =
        Http.get_ban guild.id id >>| Result.map ~f:Ban_t.of_yojson_exn

    let get_bans guild =
        Http.get_bans guild.id >>| Result.map ~f:(fun bans ->
        Yojson.Safe.Util.to_list bans
        |> List.map ~f:Ban_t.of_yojson_exn)

    let get_channel ~id guild =
        match List.find ~f:(fun c -> Channel_t.get_id c = id) guild.channels with
        | Some c -> Deferred.Or_error.return c
        | None -> Http.get_channel id >>| Result.map ~f:(fun c -> Channel_t.(channel_wrapper_of_yojson_exn c |> wrap))

    let get_emoji ~id guild =
        Http.get_emoji guild.id id >>| Result.map ~f:Emoji.of_yojson_exn

    (* TODO add invite abstraction? *)
    let get_invites guild =
        Http.get_guild_invites guild.id

    let get_member ~id guild =
        match List.find ~f:(fun m -> m.user.id = id) guild.members with
        | Some m -> Deferred.Or_error.return m
        | None -> Http.get_member guild.id id >>| Result.map ~f:Member_t.of_yojson_exn

    let get_prune_count ~days guild =
        Http.guild_prune_count guild.id days >>| Result.map ~f:(fun prune ->
        Yojson.Safe.Util.(member "pruned" prune |> to_int))

    (* TODO add HTTP fallback *)
    let get_role ~id guild =
        List.find ~f:(fun r -> r.id = id) guild.roles

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
        Yojson.Safe.Util.(member "pruned" prune |> to_int))

    let request_members guild =
        Http.get_members guild.id >>| Result.map ~f:(fun members ->
        Yojson.Safe.Util.to_list members
        |> List.map ~f:Member_t.of_yojson_exn)

    let set_afk_channel ~id guild = Http.edit_guild guild.id (`Assoc [
        ("afk_channel_id", `Int id);
        ]) >>| Result.map ~f:of_yojson_exn

    let set_afk_timeout ~timeout guild = Http.edit_guild guild.id (`Assoc [
        ("afk_timeout", `Int timeout);
        ]) >>| Result.map ~f:of_yojson_exn

    let set_name ~name guild = Http.edit_guild guild.id (`Assoc [
        ("name", `String name);
        ]) >>| Result.map ~f:of_yojson_exn

    let set_icon ~icon guild = Http.edit_guild guild.id (`Assoc [
        ("icon", `String icon);
        ]) >>| Result.map ~f:of_yojson_exn

    let unban_user ~id ?reason guild =
        let payload = match reason with
        | Some r -> `Assoc [("reason", `String r)]
        | None -> `Null
        in Http.guild_ban_remove guild.id id payload >>| Result.map ~f:ignore
end