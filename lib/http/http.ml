open Core
open Async
open Cohttp

module Base = struct
    exception Invalid_Method

    let rl = ref Rl.empty

    let base_url = "https://discordapp.com/api/v7"

    let process_url path =
        Uri.of_string (base_url ^ path)

    let process_request_body body =
        body
        |> Yojson.Safe.to_string
        |> Cohttp_async.Body.of_string

    let process_request_headers () =
        let h = Header.init () in
        Header.add_list h [
            "User-Agent", "DiscordBot (https://gitlab.com/Mishio595/disml, v0.2.3)";
            "Authorization", ("Bot " ^ !Client_options.token);
            "Content-Type", "application/json";
            "Connection", "keep-alive";
        ]

    let process_response path ((resp:Response.t), body) =
        (match Response.headers resp
        |> Rl.rl_of_header with
        | Some r -> Mvar.put (Rl.find_exn !rl path) r
        | None -> return ())
        >>= fun () ->
        match resp |> Response.status |> Code.code_of_status with
        | code when Code.is_success code -> body |> Cohttp_async.Body.to_string >>| Yojson.Safe.from_string >>= Deferred.Or_error.return
        | code ->
            body |> Cohttp_async.Body.to_string >>= fun body ->
            let headers = Response.sexp_of_t resp |> Sexp.to_string_hum in
            Logs.warn (fun m -> m "[Unsuccessful Response] [Code: %d]\n%s\n%s" code body headers);
            Deferred.Or_error.errorf "Unsuccessful response received: %d - %s" code body

    let request ?(body=`Null) ?(query=[]) m path =
        rl := Rl.update ~f:(function
            | None ->
                let r = Mvar.create () in
                Mvar.set r Rl.default;
                r
            | Some r -> r
        ) !rl path;
        let limit = Rl.find_exn !rl path in
        Mvar.take limit >>= fun limit ->
        let process () =
            let uri = Uri.add_query_params' (process_url path) query in
            let headers = process_request_headers () in
            let body = process_request_body body in
            (match m with
            | `DELETE -> Cohttp_async.Client.delete ~headers ~body uri
            | `GET -> Cohttp_async.Client.get ~headers uri
            | `PATCH -> Cohttp_async.Client.patch ~headers ~body uri
            | `POST -> Cohttp_async.Client.post ~headers ~body uri
            | `PUT -> Cohttp_async.Client.put ~headers ~body uri
            | _ -> raise Invalid_Method)
            >>= process_response path
        in if limit.remaining > 0 then process ()
        else Clock.at (Core.Time.(Span.of_int_sec limit.reset |> of_span_since_epoch)) >>= process
end

let get_gateway () =
    Base.request `GET Endpoints.gateway

let get_gateway_bot () =
    Base.request `GET Endpoints.gateway_bot

let get_channel channel_id =
    Base.request `GET (Endpoints.channel channel_id) >>| Result.map ~f:(fun c -> Channel_t.(channel_wrapper_of_yojson_exn c |> wrap))

let modify_channel channel_id body =
    Base.request ~body `PATCH (Endpoints.channel channel_id) >>| Result.map ~f:(fun c -> Channel_t.(channel_wrapper_of_yojson_exn c |> wrap))

let delete_channel channel_id =
    Base.request `DELETE (Endpoints.channel channel_id) >>| Result.map ~f:(fun c -> Channel_t.(channel_wrapper_of_yojson_exn c |> wrap))

let get_messages channel_id limit (kind, id) =
    Base.request ~query:[(kind, string_of_int id); ("limit", string_of_int limit)] `GET (Endpoints.channel_messages channel_id)
    >>| Result.map ~f:(fun l -> Yojson.Safe.Util.to_list l |> List.map ~f:Message_t.of_yojson_exn)

let get_message channel_id message_id =
    Base.request `GET (Endpoints.channel_message channel_id message_id) >>| Result.map ~f:Message_t.of_yojson_exn

let create_message channel_id body =
    Base.request ~body:body `POST (Endpoints.channel_messages channel_id) >>| Result.map ~f:Message_t.of_yojson_exn

let create_reaction channel_id message_id emoji =
    Base.request `PUT (Endpoints.channel_reaction_me channel_id message_id emoji) >>| Result.map ~f:ignore

let delete_own_reaction channel_id message_id emoji =
    Base.request `DELETE (Endpoints.channel_reaction_me channel_id message_id emoji) >>| Result.map ~f:ignore

let delete_reaction channel_id message_id emoji user_id =
    Base.request `DELETE (Endpoints.channel_reaction channel_id message_id emoji user_id) >>| Result.map ~f:ignore

let get_reactions channel_id message_id emoji =
    Base.request `GET (Endpoints.channel_reactions_get channel_id message_id emoji)
    >>| Result.map ~f:(fun l -> Yojson.Safe.Util.to_list l |> List.map ~f:User_t.of_yojson_exn)

let delete_reactions channel_id message_id =
    Base.request `DELETE (Endpoints.channel_reactions_delete channel_id message_id) >>| Result.map ~f:ignore

let edit_message channel_id message_id body =
    Base.request ~body `PATCH (Endpoints.channel_message channel_id message_id) >>| Result.map ~f:Message_t.of_yojson_exn

let delete_message channel_id message_id =
    Base.request `DELETE (Endpoints.channel_message channel_id message_id) >>| Result.map ~f:ignore

let bulk_delete channel_id body =
    Base.request ~body `POST (Endpoints.channel_bulk_delete channel_id) >>| Result.map ~f:ignore

let edit_channel_permissions channel_id overwrite_id body =
    Base.request ~body `PUT (Endpoints.channel_permission channel_id overwrite_id) >>| Result.map ~f:ignore

let get_channel_invites channel_id =
    Base.request `GET (Endpoints.channel_invites channel_id)

let create_channel_invite channel_id body =
    Base.request ~body `POST (Endpoints.channel_invites channel_id)

let delete_channel_permission channel_id overwrite_id =
    Base.request `DELETE (Endpoints.channel_permission channel_id overwrite_id) >>| Result.map ~f:ignore

let broadcast_typing channel_id =
    Base.request `POST (Endpoints.channel_typing channel_id) >>| Result.map ~f:ignore

let get_pinned_messages channel_id =
    Base.request `GET (Endpoints.channel_pins channel_id)
    >>| Result.map ~f:(fun l -> Yojson.Safe.Util.to_list l |> List.map ~f:Message_t.of_yojson_exn)

let pin_message channel_id message_id =
    Base.request `PUT (Endpoints.channel_pin channel_id message_id) >>| Result.map ~f:ignore

let unpin_message channel_id message_id =
    Base.request `DELETE (Endpoints.channel_pin channel_id message_id) >>| Result.map ~f:ignore

let group_recipient_add channel_id user_id =
    Base.request `PUT (Endpoints.group_recipient channel_id user_id) >>| Result.map ~f:ignore

let group_recipient_remove channel_id user_id =
    Base.request `DELETE (Endpoints.group_recipient channel_id user_id) >>| Result.map ~f:ignore

let get_emojis guild_id =
    Base.request `GET (Endpoints.guild_emojis guild_id)
    >>| Result.map ~f:(fun l -> Yojson.Safe.Util.to_list l |> List.map ~f:Emoji.of_yojson_exn)

let get_emoji guild_id emoji_id =
    Base.request `GET (Endpoints.guild_emoji guild_id emoji_id) >>| Result.map ~f:Emoji.of_yojson_exn

let create_emoji guild_id body =
    Base.request ~body `POST (Endpoints.guild_emojis guild_id) >>| Result.map ~f:Emoji.of_yojson_exn

let edit_emoji guild_id emoji_id body =
    Base.request ~body `PATCH (Endpoints.guild_emoji guild_id emoji_id) >>| Result.map ~f:Emoji.of_yojson_exn

let delete_emoji guild_id emoji_id =
    Base.request `DELETE (Endpoints.guild_emoji guild_id emoji_id) >>| Result.map ~f:ignore

let create_guild body =
    Base.request ~body `POST Endpoints.guilds >>| Result.map ~f:(fun g -> Guild_t.(pre_of_yojson_exn g |> wrap))

let get_guild guild_id =
    Base.request `GET (Endpoints.guild guild_id) >>| Result.map ~f:(fun g -> Guild_t.(pre_of_yojson_exn g |> wrap))

let edit_guild guild_id body =
    Base.request ~body `PATCH (Endpoints.guild guild_id) >>| Result.map ~f:(fun g -> Guild_t.(pre_of_yojson_exn g |> wrap))

let delete_guild guild_id =
    Base.request `DELETE (Endpoints.guild guild_id) >>| Result.map ~f:ignore

let get_guild_channels guild_id =
    Base.request `GET (Endpoints.guild_channels guild_id)
     >>| Result.map ~f:(fun l -> Yojson.Safe.Util.to_list l |> List.map ~f:(fun g -> Channel_t.(channel_wrapper_of_yojson_exn g |> wrap)))

let create_guild_channel guild_id body =
    Base.request ~body `POST (Endpoints.guild_channels guild_id) >>| Result.map ~f:(fun c -> Channel_t.(channel_wrapper_of_yojson_exn c |> wrap))

let modify_guild_channel_positions guild_id body =
    Base.request ~body `PATCH (Endpoints.guild_channels guild_id) >>| Result.map ~f:ignore

let get_member guild_id user_id =
    Base.request `GET (Endpoints.guild_member guild_id user_id) >>| Result.map ~f:(fun m -> Member_t.(member_of_yojson_exn m |> wrap ~guild_id))

let get_members guild_id =
    Base.request `GET (Endpoints.guild_members guild_id)
    >>| Result.map ~f:(fun l -> Yojson.Safe.Util.to_list l |> List.map ~f:(fun m -> Member_t.(member_of_yojson_exn m |> wrap ~guild_id)))

let add_member guild_id user_id body =
    Base.request ~body `PUT (Endpoints.guild_member guild_id user_id)
    >>| Result.map ~f:(fun m -> Member_t.(member_of_yojson_exn m |> wrap ~guild_id))

let edit_member guild_id user_id body =
    Base.request ~body `PATCH (Endpoints.guild_member guild_id user_id) >>| Result.map ~f:ignore

let remove_member guild_id user_id body =
    Base.request ~body `DELETE (Endpoints.guild_member guild_id user_id) >>| Result.map ~f:ignore

let change_nickname guild_id body =
    Base.request ~body `PATCH (Endpoints.guild_me_nick guild_id)

let add_member_role guild_id user_id role_id =
    Base.request `PUT (Endpoints.guild_member_role guild_id user_id role_id) >>| Result.map ~f:ignore

let remove_member_role guild_id user_id role_id =
    Base.request `DELETE (Endpoints.guild_member_role guild_id user_id role_id) >>| Result.map ~f:ignore

let get_bans guild_id =
    Base.request `GET (Endpoints.guild_bans guild_id)
    >>| Result.map ~f:(fun l -> Yojson.Safe.Util.to_list l |> List.map ~f:Ban_t.of_yojson_exn)

let get_ban guild_id user_id =
    Base.request `GET (Endpoints.guild_ban guild_id user_id) >>| Result.map ~f:Ban_t.of_yojson_exn

let guild_ban_add guild_id user_id body =
    Base.request ~body `PUT (Endpoints.guild_ban guild_id user_id) >>| Result.map ~f:ignore

let guild_ban_remove guild_id user_id body =
    Base.request ~body `DELETE (Endpoints.guild_ban guild_id user_id) >>| Result.map ~f:ignore

let get_roles guild_id =
    Base.request `GET (Endpoints.guild_roles guild_id)
    >>| Result.map ~f:(fun l -> Yojson.Safe.Util.to_list l |> List.map ~f:(fun r -> Role_t.(role_of_yojson_exn r |> wrap ~guild_id)))

let guild_role_add guild_id body =
    Base.request ~body `POST (Endpoints.guild_roles guild_id) >>| Result.map ~f:(fun r -> Role_t.(role_of_yojson_exn r |> wrap ~guild_id))

let guild_roles_edit guild_id body =
    Base.request ~body `PATCH (Endpoints.guild_roles guild_id)
    >>| Result.map ~f:(fun l -> Yojson.Safe.Util.to_list l |> List.map ~f:(fun r -> Role_t.(role_of_yojson_exn r |> wrap ~guild_id)))

let guild_role_edit guild_id role_id body =
    Base.request ~body `PATCH (Endpoints.guild_role guild_id role_id) >>| Result.map ~f:(fun r -> Role_t.(role_of_yojson_exn r |> wrap ~guild_id))

let guild_role_remove guild_id role_id =
    Base.request `DELETE (Endpoints.guild_role guild_id role_id) >>| Result.map ~f:ignore

let guild_prune_count guild_id days =
    Base.request ~query:[("days", Int.to_string days)] `GET (Endpoints.guild_prune guild_id)
    >>| Result.map ~f:(fun c -> Yojson.Safe.Util.(member "pruned" c |> to_int))

let guild_prune_start guild_id days =
    Base.request ~query:[("days", Int.to_string days)] `POST (Endpoints.guild_prune guild_id)
    >>| Result.map ~f:(fun c -> Yojson.Safe.Util.(member "pruned" c |> to_int))

let get_guild_voice_regions guild_id =
    Base.request `GET (Endpoints.guild_voice_regions guild_id)

let get_guild_invites guild_id =
    Base.request `GET (Endpoints.guild_invites guild_id)

let get_integrations guild_id =
    Base.request `GET (Endpoints.guild_integrations guild_id)

let add_integration guild_id body =
    Base.request ~body `POST (Endpoints.guild_integrations guild_id) >>| Result.map ~f:ignore

let edit_integration guild_id integration_id body =
    Base.request ~body `POST (Endpoints.guild_integration guild_id integration_id) >>| Result.map ~f:ignore

let delete_integration guild_id integration_id =
    Base.request `DELETE (Endpoints.guild_integration guild_id integration_id) >>| Result.map ~f:ignore

let sync_integration guild_id integration_id =
    Base.request `POST (Endpoints.guild_integration_sync guild_id integration_id) >>| Result.map ~f:ignore

let get_guild_embed guild_id =
    Base.request `GET (Endpoints.guild_embed guild_id)

let edit_guild_embed guild_id body =
    Base.request ~body `PATCH (Endpoints.guild_embed guild_id)

let get_vanity_url guild_id =
    Base.request `GET (Endpoints.guild_vanity_url guild_id)

let get_invite invite_code =
    Base.request `GET (Endpoints.invite invite_code)

let delete_invite invite_code =
    Base.request `DELETE (Endpoints.invite invite_code)

let get_current_user () =
    Base.request `GET Endpoints.me >>| Result.map ~f:User_t.of_yojson_exn

let edit_current_user body =
    Base.request ~body `PATCH Endpoints.me >>| Result.map ~f:User_t.of_yojson_exn

let get_guilds () =
    Base.request `GET Endpoints.me_guilds
     >>| Result.map ~f:(fun l -> Yojson.Safe.Util.to_list l |> List.map ~f:(fun g -> Guild_t.(pre_of_yojson_exn g |> wrap)))

let leave_guild guild_id =
    Base.request `DELETE (Endpoints.me_guild guild_id) >>| Result.map ~f:ignore

let get_private_channels () =
    Base.request `GET Endpoints.me_channels

let create_dm body =
    Base.request ~body `POST Endpoints.me_channels

let create_group_dm body =
    Base.request ~body `POST Endpoints.me_channels

let get_connections () =
    Base.request `GET Endpoints.me_connections

let get_user user_id =
    Base.request `GET (Endpoints.user user_id) >>| Result.map ~f:User_t.of_yojson_exn

let get_voice_regions () =
    Base.request `GET Endpoints.regions

let create_webhook channel_id body =
    Base.request ~body `POST (Endpoints.webhooks_channel channel_id)

let get_channel_webhooks channel_id =
    Base.request `GET (Endpoints.webhooks_channel channel_id)

let get_guild_webhooks guild_id =
    Base.request `GET (Endpoints.webhooks_guild guild_id)

let get_webhook webhook_id =
    Base.request `GET (Endpoints.webhook webhook_id)

let get_webhook_with_token webhook_id token =
    Base.request `GET (Endpoints.webhook_token webhook_id token)

let edit_webhook webhook_id body =
    Base.request ~body `PATCH (Endpoints.webhook webhook_id)

let edit_webhook_with_token webhook_id token body =
    Base.request ~body `PATCH (Endpoints.webhook_token webhook_id token)

let delete_webhook webhook_id =
    Base.request `DELETE (Endpoints.webhook webhook_id) >>| Result.map ~f:ignore

let delete_webhook_with_token webhook_id token =
    Base.request `DELETE (Endpoints.webhook_token webhook_id token) >>| Result.map ~f:ignore

let execute_webhook webhook_id token body =
    Base.request ~body `POST (Endpoints.webhook_token webhook_id token)

let execute_slack_webhook webhook_id token body =
    Base.request ~body `POST (Endpoints.webhook_slack webhook_id token)

let execute_git_webhook webhook_id token body =
    Base.request ~body `POST (Endpoints.webhook_git webhook_id token)

let get_audit_logs guild_id body =
    Base.request ~body `GET (Endpoints.guild_audit_logs guild_id)

let get_application_info () =
    Base.request `GET (Endpoints.application_information)