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
    match ev with
    | "MESSAGE_CREATE" -> client.handler <- { client.handler with message_create = Some(fn) }
    | _ -> ()

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