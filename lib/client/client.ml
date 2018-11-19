open Async

type t = {
    sharder: Sharder.t Ivar.t;
    (* events: (Events.t, Core_kernel.write) Bvar.t list; *)
    mutable handler: Sharder.handler;
    token: string;
}

let make ?handler token =
    let handler = match handler with
    | Some h -> h
    | None -> begin
        Sharder.{
            ready = None;
            resumed = None;
            channel_create = None;
            channel_delete = None;
            channel_update = None;
            channel_pins_update = None;
            guild_create = None;
            guild_delete = None;
            guild_update = None;
            guild_ban_add = None;
            guild_ban_remove = None;
            guild_emojis_update = None;
            guild_integrations_update = None;
            guild_member_add = None;
            guild_member_remove = None;
            guild_member_update = None;
            guild_members_chunk = None;
            guild_role_create = None;
            guild_role_delete = None;
            guild_role_update = None;
            message_create = None;
            message_delete = None;
            message_update = None;
            message_delete_bulk = None;
            message_reaction_add = None;
            message_reaction_remove = None;
            message_reaction_remove_all = None;
            presence_update = None;
            typing_start = None;
            user_update = None;
            voice_state_update = None;
            voice_server_update = None;
            webhooks_update = None;
        }
    end in
    {
        sharder = Ivar.create ();
        handler;
        token;
    }

let start ?count client =
    Sharder.start ?count ~handler:client.handler client.token
    >>| fun sharder ->
    Ivar.fill_if_empty client.sharder sharder;
    client

let on ev client fn =
    client.handler <- (match ev with
    | "READY" -> { client.handler with ready = Some(fn) }
    | "RESUMED" -> { client.handler with resumed = Some(fn) }
    | "CHANNEL_CREATE" -> { client.handler with channel_create = Some(fn) }
    | "CHANNEL_DELETE" -> { client.handler with channel_delete = Some(fn) }
    | "CHANNEL_UPDATE" -> { client.handler with channel_update = Some(fn) }
    | "CHANNEL_PINS_UPDATE" -> { client.handler with channel_pins_update = Some(fn) }
    | "GUILD_CREATE" -> { client.handler with guild_create = Some(fn) }
    | "GUILD_DELETE" -> { client.handler with guild_delete = Some(fn) }
    | "GUILD_UPDATE" -> { client.handler with guild_update = Some(fn) }
    | "GUILD_BAN_ADD" -> { client.handler with guild_ban_add = Some(fn) }
    | "GUILD_BAN_REMOVE" -> { client.handler with guild_ban_remove = Some(fn) }
    | "GUILD_EMOJIS_UPDATE" -> { client.handler with guild_emojis_update = Some(fn) }
    | "GUILD_INTEGRATIONS_UPDATE" -> { client.handler with guild_integrations_update = Some(fn) }
    | "GUILD_MEMBER_ADD" -> { client.handler with guild_member_add = Some(fn) }
    | "GUILD_MEMBER_REMOVE" -> { client.handler with guild_member_remove = Some(fn) }
    | "GUILD_MEMBER_UPDATE" -> { client.handler with guild_member_update = Some(fn) }
    | "GUILD_MEMBERS_CHUNK" -> { client.handler with guild_members_chunk = Some(fn) }
    | "GUILD_ROLE_CREATE" -> { client.handler with guild_role_create = Some(fn) }
    | "GUILD_ROLE_DELETE" -> { client.handler with guild_role_delete = Some(fn) }
    | "GUILD_ROLE_UPDATE" -> { client.handler with guild_role_update = Some(fn) }
    | "MESSAGE_CREATE" -> { client.handler with message_create = Some(fn) }
    | "MESSAGE_DELETE" -> { client.handler with message_delete = Some(fn) }
    | "MESSAGE_UPDATE" -> { client.handler with message_update = Some(fn) }
    | "MESSAGE_DELETE_BULK" -> { client.handler with message_delete_bulk = Some(fn) }
    | "MESSAGE_REACTION_ADD" -> { client.handler with message_reaction_add = Some(fn) }
    | "MESSAGE_REACTION_REMOVE" -> { client.handler with message_reaction_remove = Some(fn) }
    | "MESSAGE_REACTION_REMOVE_ALL" -> { client.handler with message_reaction_remove_all = Some(fn) }
    | "PRESENCE_UPDATE" -> { client.handler with presence_update = Some(fn) }
    | "TYPING_START" -> { client.handler with typing_start = Some(fn) }
    | "USER_UPDATE" -> { client.handler with user_update = Some(fn) }
    | "VOICE_STATE_UPDATE" -> { client.handler with voice_state_update = Some(fn) }
    | "VOICE_SERVER_UPDATE" -> { client.handler with voice_server_update = Some(fn) }
    | "WEBHOOKS_UPDATE" -> { client.handler with webhooks_update = Some(fn) }
    | _ -> client.handler);
    match Ivar.peek client.sharder with
    | Some s -> Sharder.update_handler s client.handler;
    | None -> ()


let set_status client status =
    Ivar.read client.sharder
    >>= fun sharder ->
    Sharder.set_status sharder status

let set_status_with client f =
    Ivar.read client.sharder
    >>= fun sharder ->
    Sharder.set_status_with sharder f

let request_guild_members ~guild ?query ?limit client =
    Ivar.read client.sharder
    >>= fun sharder ->
    Sharder.request_guild_members ~guild ?query ?limit sharder