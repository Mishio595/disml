module Channel(T : S.Has_snowflake) : S.ChannelImpl with type t := T.t = struct
    open Async
    open Core
    include T

    exception Invalid_message
    exception No_message_found

    let send_message ?embed ?content ?file ?(tts=false) ch =
        let embed = match embed with
        | Some e -> Embed.to_yojson e
        | None -> `Null in
        let content = match content with
        | Some c -> `String c
        | None -> `Null in
        let file = match file with
        | Some f -> `String f
        | None -> `Null in
        let () = match embed, content with
        | `Null, `Null -> raise Invalid_message
        | _ -> () in
        Http.create_message (get_id ch) (`Assoc [
            ("embed", embed);
            ("content", content);
            ("file", file);
            ("tts", `Bool tts);
        ]) >>| Result.map ~f:Message_t.of_yojson_exn

    let say content ch =
        send_message ~content ch

    let delete ch =
        Http.delete_channel (get_id ch) >>| Result.map ~f:ignore

    let get_message ~id ch =
        Http.get_message (get_id ch) id >>| Result.map ~f:Message_t.of_yojson_exn

    let get_messages ?(mode=`Around) ?id ?(limit=50) ch =
        let kind = match mode with
        | `Around -> "around", limit
        | `Before -> "before", limit
        | `After -> "after", limit
        in
        let id = match id with
        | Some id -> id
        | None -> raise No_message_found in
        Http.get_messages (get_id ch) id kind >>| Result.map ~f:(fun l ->
            Yojson.Safe.Util.to_list l
            |> List.map ~f:Message_t.of_yojson_exn)

    let broadcast_typing ch =
        Http.broadcast_typing (get_id ch) >>| Result.map ~f:ignore

    let get_pins ch =
        Http.get_pinned_messages (get_id ch) >>| Result.map ~f:(fun l ->
            Yojson.Safe.Util.to_list l
            |> List.map ~f:Message_t.of_yojson_exn)
end

module Guild(T : S.Has_snowflake) : S.GuildImpl with type t := T.t = struct
    open Core
    open Async
    include T

    let ban_user ~id ?(reason="") ?(days=0) guild =
        Http.guild_ban_add (get_id guild) id (`Assoc [
            ("delete-message-days", `Int days);
            ("reason", `String reason);
        ]) >>| Result.map ~f:ignore

    let create_emoji ~name ~image guild =
        Http.create_emoji (get_id guild) (`Assoc [
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
        in Http.guild_role_add (get_id guild) (`Assoc payload)
            >>| Result.map ~f:(fun r -> Role_t.role_of_yojson_exn r |> Role_t.wrap ~guild_id:(get_id guild))

    let create_channel ~mode ~name guild =
        let kind = match mode with
        | `Text -> 0
        | `Voice -> 2
        | `Category -> 4
        in Http.create_guild_channel (get_id guild) (`Assoc [
            ("name", `String name);
            ("type", `Int kind);
        ]) >>| Result.map ~f:Channel_t.of_yojson_exn

    let delete guild = 
        Http.delete_guild (get_id guild) >>| Result.map ~f:ignore

    let get_ban ~id guild =
        Http.get_ban (get_id guild) id >>| Result.map ~f:Ban_t.of_yojson_exn

    let get_bans guild =
        Http.get_bans (get_id guild) >>| Result.map ~f:(fun bans ->
        Yojson.Safe.Util.to_list bans
        |> List.map ~f:Ban_t.of_yojson_exn)

    let get_emoji ~id guild =
        Http.get_emoji (get_id guild) id >>| Result.map ~f:Emoji.of_yojson_exn

    (* TODO add invite abstraction? *)
    let get_invites guild =
        Http.get_guild_invites (get_id guild)

    let get_prune_count ~days guild =
        Http.guild_prune_count (get_id guild) days >>| Result.map ~f:(fun prune ->
        Yojson.Safe.Util.(member "pruned" prune |> to_int))

    (* TODO add webhook abstraction? *)
    let get_webhooks guild =
        Http.get_guild_webhooks (get_id guild)

    let kick_user ~id ?reason guild =
        let payload = match reason with
        | Some r -> `Assoc [("reason", `String r)]
        | None -> `Null
        in Http.remove_member (get_id guild) id payload >>| Result.map ~f:ignore

    let leave guild =
        Http.leave_guild (get_id guild)

    (* TODO Voice region abstractions? *)
    let list_voice_regions guild =
        Http.get_guild_voice_regions (get_id guild)

    let prune ~days guild =
        Http.guild_prune_start (get_id guild) days >>| Result.map ~f:(fun prune ->
        Yojson.Safe.Util.(member "pruned" prune |> to_int))

    let request_members guild =
        Http.get_members (get_id guild) >>| Result.map ~f:(fun members ->
        Yojson.Safe.Util.to_list members
        |> List.map ~f:Member_t.of_yojson_exn)

    let set_afk_channel ~id guild = Http.edit_guild (get_id guild) (`Assoc [
        ("afk_channel_id", `Int id);
        ]) >>| Result.map ~f:of_yojson_exn

    let set_afk_timeout ~timeout guild = Http.edit_guild (get_id guild) (`Assoc [
        ("afk_timeout", `Int timeout);
        ]) >>| Result.map ~f:of_yojson_exn

    let set_name ~name guild = Http.edit_guild (get_id guild) (`Assoc [
        ("name", `String name);
        ]) >>| Result.map ~f:of_yojson_exn

    let set_icon ~icon guild = Http.edit_guild (get_id guild) (`Assoc [
        ("icon", `String icon);
        ]) >>| Result.map ~f:of_yojson_exn

    let unban_user ~id ?reason guild =
        let payload = match reason with
        | Some r -> `Assoc [("reason", `String r)]
        | None -> `Null
        in Http.guild_ban_remove (get_id guild) id payload >>| Result.map ~f:ignore
end