open Async
open Core
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

let dispatch ev =
    match ev with
    | READY d ->
        Mvar.update_exn Cache.cache ~f:(fun cache -> Ready.update_cache cache d);
        !Dispatch.ready d
    | RESUMED d ->
        Mvar.update_exn Cache.cache ~f:(fun cache -> Resumed.update_cache cache d);
        !Dispatch.resumed d
    | CHANNEL_CREATE d ->
        Mvar.update_exn Cache.cache ~f:(fun cache -> ChannelCreate.update_cache cache d);
        !Dispatch.channel_create d
    | CHANNEL_UPDATE d ->
        Mvar.update_exn Cache.cache ~f:(fun cache -> ChannelUpdate.update_cache cache d);
        !Dispatch.channel_update d
    | CHANNEL_DELETE d ->
        Mvar.update_exn Cache.cache ~f:(fun cache -> ChannelDelete.update_cache cache d);
        !Dispatch.channel_delete d
    | CHANNEL_PINS_UPDATE d ->
        Mvar.update_exn Cache.cache ~f:(fun cache -> ChannelPinsUpdate.update_cache cache d);
        !Dispatch.channel_pins_update d
    | GUILD_CREATE d ->
        Mvar.update_exn Cache.cache ~f:(fun cache -> GuildCreate.update_cache cache d);
        !Dispatch.guild_create d
    | GUILD_UPDATE d ->
        Mvar.update_exn Cache.cache ~f:(fun cache -> GuildUpdate.update_cache cache d);
        !Dispatch.guild_update d
    | GUILD_DELETE d ->
        Mvar.update_exn Cache.cache ~f:(fun cache -> GuildDelete.update_cache cache d);
        !Dispatch.guild_delete d
    | GUILD_BAN_ADD d ->
        Mvar.update_exn Cache.cache ~f:(fun cache -> GuildBanAdd.update_cache cache d);
        !Dispatch.member_ban d
    | GUILD_BAN_REMOVE d ->
        Mvar.update_exn Cache.cache ~f:(fun cache -> GuildBanRemove.update_cache cache d);
        !Dispatch.member_unban d
    | GUILD_EMOJIS_UPDATE d ->
        Mvar.update_exn Cache.cache ~f:(fun cache -> GuildEmojisUpdate.update_cache cache d);
        !Dispatch.guild_emojis_update d
    (* | GUILD_INTEGRATIONS_UPDATE d -> !Dispatch.integrations_update d *)
    | GUILD_MEMBER_ADD d ->
        Mvar.update_exn Cache.cache ~f:(fun cache -> GuildMemberAdd.update_cache cache d);
        !Dispatch.member_join d
    | GUILD_MEMBER_REMOVE d ->
        Mvar.update_exn Cache.cache ~f:(fun cache -> GuildMemberRemove.update_cache cache d);
        !Dispatch.member_leave d
    | GUILD_MEMBER_UPDATE d ->
        Mvar.update_exn Cache.cache ~f:(fun cache -> GuildMemberUpdate.update_cache cache d);
        !Dispatch.member_update d
    | GUILD_MEMBERS_CHUNK d ->
        Mvar.update_exn Cache.cache ~f:(fun cache -> GuildMembersChunk.update_cache cache d);
        !Dispatch.members_chunk d
    | GUILD_ROLE_CREATE d ->
        Mvar.update_exn Cache.cache ~f:(fun cache -> GuildRoleCreate.update_cache cache d);
        !Dispatch.role_create d
    | GUILD_ROLE_UPDATE d ->
        Mvar.update_exn Cache.cache ~f:(fun cache -> GuildRoleUpdate.update_cache cache d);
        !Dispatch.role_update d
    | GUILD_ROLE_DELETE d ->
        Mvar.update_exn Cache.cache ~f:(fun cache -> GuildRoleDelete.update_cache cache d);
        !Dispatch.role_delete d
    | MESSAGE_CREATE d ->
        Mvar.update_exn Cache.cache ~f:(fun cache -> MessageCreate.update_cache cache d);
        !Dispatch.message_create d
    | MESSAGE_UPDATE d ->
        Mvar.update_exn Cache.cache ~f:(fun cache -> MessageUpdate.update_cache cache d);
        !Dispatch.message_update d
    | MESSAGE_DELETE d ->
        Mvar.update_exn Cache.cache ~f:(fun cache -> MessageDelete.update_cache cache d);
        !Dispatch.message_delete d
    | MESSAGE_DELETE_BULK d ->
        Mvar.update_exn Cache.cache ~f:(fun cache -> MessageDeleteBulk.update_cache cache d);
        !Dispatch.message_delete_bulk d
    | REACTION_ADD d ->
        Mvar.update_exn Cache.cache ~f:(fun cache -> ReactionAdd.update_cache cache d);
        !Dispatch.reaction_add d
    | REACTION_REMOVE d ->
        Mvar.update_exn Cache.cache ~f:(fun cache -> ReactionRemove.update_cache cache d);
        !Dispatch.reaction_remove d
    | REACTION_REMOVE_ALL d ->
        Mvar.update_exn Cache.cache ~f:(fun cache -> ReactionRemoveAll.update_cache cache d);
        !Dispatch.reaction_remove_all d
    | PRESENCE_UPDATE d ->
        Mvar.update_exn Cache.cache ~f:(fun cache -> PresenceUpdate.update_cache cache d);
        !Dispatch.presence_update d
    | TYPING_START d ->
        Mvar.update_exn Cache.cache ~f:(fun cache -> TypingStart.update_cache cache d);
        !Dispatch.typing_start d
    | USER_UPDATE d ->
        Mvar.update_exn Cache.cache ~f:(fun cache -> UserUpdate.update_cache cache d);
        !Dispatch.user_update d
    (* | VOICE_STATE_UPDATE d -> !Dispatch.voice_state_update d *)
    (* | VOICE_SERVER_UPDATE d -> !Dispatch.voice_server_update d *)
    | WEBHOOK_UPDATE d ->
        Mvar.update_exn Cache.cache ~f:(fun cache -> WebhookUpdate.update_cache cache d);
        !Dispatch.webhook_update d
    | UNKNOWN d -> !Dispatch.unknown d

let handle_event ~ev contents =
    event_of_yojson ~contents ev
    |> dispatch