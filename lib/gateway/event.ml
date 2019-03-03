open Lwt.Infix
open Event_models

type t =
| READY of Ready.t
| RESUMED of Resumed.t
| CHANNEL_CREATE of ChannelCreate.t
| CHANNEL_UPDATE of ChannelUpdate.t
| CHANNEL_DELETE of ChannelDelete.t
| CHANNEL_PINS_UPDATE of ChannelPinsUpdate.t
| GUILD_CREATE of GuildCreate.t
| GUILD_UPDATE of GuildUpdate.t
| GUILD_DELETE of GuildDelete.t
| GUILD_BAN_ADD of GuildBanAdd.t
| GUILD_BAN_REMOVE of GuildBanRemove.t
| GUILD_EMOJIS_UPDATE of GuildEmojisUpdate.t
(* | GUILD_INTEGRATIONS_UPDATE of Yojson.Safe.t *)
| GUILD_MEMBER_ADD of GuildMemberAdd.t
| GUILD_MEMBER_REMOVE of GuildMemberRemove.t
| GUILD_MEMBER_UPDATE of GuildMemberUpdate.t
| GUILD_MEMBERS_CHUNK of GuildMembersChunk.t
| GUILD_ROLE_CREATE of GuildRoleCreate.t
| GUILD_ROLE_UPDATE of GuildRoleUpdate.t
| GUILD_ROLE_DELETE of GuildRoleDelete.t
| MESSAGE_CREATE of MessageCreate.t
| MESSAGE_UPDATE of MessageUpdate.t
| MESSAGE_DELETE of MessageDelete.t
| MESSAGE_DELETE_BULK of MessageDeleteBulk.t
| REACTION_ADD of ReactionAdd.t
| REACTION_REMOVE of ReactionRemove.t
| REACTION_REMOVE_ALL of ReactionRemoveAll.t
| PRESENCE_UPDATE of PresenceUpdate.t
| TYPING_START of TypingStart.t
| USER_UPDATE of UserUpdate.t
(* | VOICE_STATE_UPDATE of Yojson.Safe.t *)
(* | VOICE_SERVER_UPDATE of Yojson.Safe.t *)
| WEBHOOK_UPDATE of WebhookUpdate.t
| UNKNOWN of Unknown.t

let event_of_yojson ~contents = function
    | "READY" -> READY Ready.(deserialize contents)
    | "RESUMED" -> RESUMED Resumed.(deserialize contents)
    | "CHANNEL_CREATE" -> CHANNEL_CREATE ChannelCreate.(deserialize contents)
    | "CHANNEL_UPDATE" -> CHANNEL_UPDATE ChannelUpdate.(deserialize contents)
    | "CHANNEL_DELETE" -> CHANNEL_DELETE ChannelDelete.(deserialize contents)
    | "CHANNEL_PINS_UPDATE" -> CHANNEL_PINS_UPDATE ChannelPinsUpdate.(deserialize contents)
    | "GUILD_CREATE" -> GUILD_CREATE GuildCreate.(deserialize contents)
    | "GUILD_UPDATE" -> GUILD_UPDATE GuildUpdate.(deserialize contents)
    | "GUILD_DELETE" -> GUILD_DELETE GuildDelete.(deserialize contents)
    | "GUILD_BAN_ADD" -> GUILD_BAN_ADD GuildBanAdd.(deserialize contents)
    | "GUILD_BAN_REMOVE" -> GUILD_BAN_REMOVE GuildBanRemove.(deserialize contents)
    | "GUILD_EMOJIS_UPDATE" -> GUILD_EMOJIS_UPDATE GuildEmojisUpdate.(deserialize contents)
    (* | "GUILD_INTEGRATIONS_UPDATE" -> GUILD_INTEGRATIONS_UPDATE contents *)
    | "GUILD_MEMBER_ADD" -> GUILD_MEMBER_ADD GuildMemberAdd.(deserialize contents)
    | "GUILD_MEMBER_REMOVE" -> GUILD_MEMBER_REMOVE GuildMemberRemove.(deserialize contents)
    | "GUILD_MEMBER_UPDATE" -> GUILD_MEMBER_UPDATE GuildMemberUpdate.(deserialize contents)
    | "GUILD_MEMBERS_CHUNK" -> GUILD_MEMBERS_CHUNK GuildMembersChunk.(deserialize contents)
    | "GUILD_ROLE_CREATE" -> GUILD_ROLE_CREATE GuildRoleCreate.(deserialize contents)
    | "GUILD_ROLE_UPDATE" -> GUILD_ROLE_UPDATE GuildRoleUpdate.(deserialize contents)
    | "GUILD_ROLE_DELETE" -> GUILD_ROLE_DELETE GuildRoleDelete.(deserialize contents)
    | "MESSAGE_CREATE" -> MESSAGE_CREATE MessageCreate.(deserialize contents)
    | "MESSAGE_UPDATE" -> MESSAGE_UPDATE MessageUpdate.(deserialize contents)
    | "MESSAGE_DELETE" -> MESSAGE_DELETE MessageDelete.(deserialize contents)
    | "MESSAGE_DELETE_BULK" -> MESSAGE_DELETE_BULK MessageDeleteBulk.(deserialize contents)
    | "MESSAGE_REACTION_ADD" -> REACTION_ADD ReactionAdd.(deserialize contents)
    | "MESSAGE_REACTION_REMOVE" -> REACTION_REMOVE ReactionRemove.(deserialize contents)
    | "MESSAGE_REACTION_REMOVE_ALL" -> REACTION_REMOVE_ALL ReactionRemoveAll.(deserialize contents)
    | "PRESENCE_UPDATE" -> PRESENCE_UPDATE PresenceUpdate.(deserialize contents)
    | "TYPING_START" -> TYPING_START TypingStart.(deserialize contents)
    | "USER_UPDATE" -> USER_UPDATE UserUpdate.(deserialize contents)
    (* | "VOICE_STATE_UPDATE" -> VOICE_STATE_UPDATE contents *)
    (* | "VOICE_SERVER_UPDATE" -> VOICE_SERVER_UPDATE contents *)
    | "WEBHOOK_UPDATE" -> WEBHOOK_UPDATE WebhookUpdate.(deserialize contents)
    | s -> UNKNOWN Unknown.(deserialize s contents)

let dispatch cache ev =
    match ev with
    | READY d ->
        let cache = Ready.update_cache cache d in
        Lwt.async (fun () -> !Dispatch.ready d);
        cache
    | RESUMED d ->
        let cache = Resumed.update_cache cache d in
        Lwt.async (fun () -> !Dispatch.resumed d);
        cache
    | CHANNEL_CREATE d ->
        let cache = ChannelCreate.update_cache cache d in
        Lwt.async (fun () -> !Dispatch.channel_create d);
        cache
    | CHANNEL_UPDATE d ->
        let cache = ChannelDelete.update_cache cache d in
        Lwt.async (fun () -> !Dispatch.channel_update d);
        cache
    | CHANNEL_DELETE d ->
        let cache = ChannelDelete.update_cache cache d in
        Lwt.async (fun () -> !Dispatch.channel_delete d);
        cache
    | CHANNEL_PINS_UPDATE d ->
        let cache = ChannelPinsUpdate.update_cache cache d in
        Lwt.async (fun () -> !Dispatch.channel_pins_update d);
        cache
    | GUILD_CREATE d ->
        let cache = GuildCreate.update_cache cache d in
        Lwt.async (fun () -> !Dispatch.guild_create d);
        cache
    | GUILD_UPDATE d ->
        let cache = GuildUpdate.update_cache cache d in
        Lwt.async (fun () -> !Dispatch.guild_update d);
        cache
    | GUILD_DELETE d ->
        let cache = GuildDelete.update_cache cache d in
        Lwt.async (fun () -> !Dispatch.guild_delete d);
        cache
    | GUILD_BAN_ADD d ->
        let cache = GuildBanAdd.update_cache cache d in
        Lwt.async (fun () -> !Dispatch.member_ban d);
        cache
    | GUILD_BAN_REMOVE d ->
        let cache = GuildBanRemove.update_cache cache d in
        Lwt.async (fun () -> !Dispatch.member_unban d);
        cache
    | GUILD_EMOJIS_UPDATE d ->
        let cache = GuildEmojisUpdate.update_cache cache d in
        Lwt.async (fun () -> !Dispatch.guild_emojis_update d);
        cache
    (* | GUILD_INTEGRATIONS_UPDATE d -> !Dispatch.integrations_update d *)
    | GUILD_MEMBER_ADD d ->
        let cache = GuildMemberAdd.update_cache cache d in
        Lwt.async (fun () -> !Dispatch.member_join d);
        cache
    | GUILD_MEMBER_REMOVE d ->
        let cache = GuildMemberRemove.update_cache cache d in
        Lwt.async (fun () -> !Dispatch.member_leave d);
        cache
    | GUILD_MEMBER_UPDATE d ->
        let cache = GuildMemberUpdate.update_cache cache d in
        Lwt.async (fun () -> !Dispatch.member_update d);
        cache
    | GUILD_MEMBERS_CHUNK d ->
        let cache = GuildMembersChunk.update_cache cache d in
        Lwt.async (fun () -> !Dispatch.members_chunk d);
        cache
    | GUILD_ROLE_CREATE d ->
        let cache = GuildRoleCreate.update_cache cache d in
        Lwt.async (fun () -> !Dispatch.role_create d);
        cache
    | GUILD_ROLE_UPDATE d ->
        let cache = GuildRoleUpdate.update_cache cache d in
        Lwt.async (fun () -> !Dispatch.role_update d);
        cache
    | GUILD_ROLE_DELETE d ->
        let cache = GuildRoleDelete.update_cache cache d in
        Lwt.async (fun () -> !Dispatch.role_delete d);
        cache
    | MESSAGE_CREATE d ->
        let cache = MessageCreate.update_cache cache d in
        Lwt.async (fun () -> !Dispatch.message_create d);
        cache
    | MESSAGE_UPDATE d ->
        let cache = MessageUpdate.update_cache cache d in
        Lwt.async (fun () -> !Dispatch.message_update d);
        cache
    | MESSAGE_DELETE d ->
        let cache = MessageDelete.update_cache cache d in
        Lwt.async (fun () -> !Dispatch.message_delete d);
        cache
    | MESSAGE_DELETE_BULK d ->
        let cache = MessageDeleteBulk.update_cache cache d in
        Lwt.async (fun () -> !Dispatch.message_delete_bulk d);
        cache
    | REACTION_ADD d ->
        let cache = ReactionAdd.update_cache cache d in
        Lwt.async (fun () -> !Dispatch.reaction_add d);
        cache
    | REACTION_REMOVE d ->
        let cache = ReactionRemove.update_cache cache d in
        Lwt.async (fun () -> !Dispatch.reaction_remove d);
        cache
    | REACTION_REMOVE_ALL d ->
        let cache = ReactionRemoveAll.update_cache cache d in
        Lwt.async (fun () -> !Dispatch.reaction_remove_all d);
        cache
    | PRESENCE_UPDATE d ->
        let cache = PresenceUpdate.update_cache cache d in
        Lwt.async (fun () -> !Dispatch.presence_update d);
        cache
    | TYPING_START d ->
        let cache = TypingStart.update_cache cache d in
        Lwt.async (fun () -> !Dispatch.typing_start d);
        cache
    | USER_UPDATE d ->
        let cache = UserUpdate.update_cache cache d in
        Lwt.async (fun () -> !Dispatch.user_update d);
        cache
    (* | VOICE_STATE_UPDATE d -> !Dispatch.voice_state_update d *)
    (* | VOICE_SERVER_UPDATE d -> !Dispatch.voice_server_update d *)
    | WEBHOOK_UPDATE d ->
        let cache = WebhookUpdate.update_cache cache d in
        Lwt.async (fun () -> !Dispatch.webhook_update d);
        cache
    | UNKNOWN d ->
        Lwt.async (fun () -> !Dispatch.unknown d);
        cache

let handle_event ~ev contents =
    Lwt_mvar.take Cache.cache >>= fun cache ->
    event_of_yojson ~contents ev
    |> dispatch cache
    |> Lwt_mvar.put Cache.cache