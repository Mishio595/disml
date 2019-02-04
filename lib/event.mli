(** Barebones of event dispatching. Most users will have no reason to look here. *)

open Event_models

(** Event dispatch type wrapper. Used internally. *)
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

(** Used to convert an event string and payload into a t wrapper type. *)
val event_of_yojson : contents:Yojson.Safe.t -> string -> t

(** Sends the event to the registered handler. *)
val dispatch : t -> unit

(** Wrapper to other functions. This is called from the shards. *)
val handle_event : ev:string -> Yojson.Safe.t -> unit