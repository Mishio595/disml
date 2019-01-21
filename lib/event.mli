exception Invalid_event of string

type t =
| HELLO of Yojson.Safe.json
| READY of Yojson.Safe.json
| RESUMED of Yojson.Safe.json
| INVALID_SESSION of Yojson.Safe.json
| CHANNEL_CREATE of Channel_t.t
| CHANNEL_UPDATE of Channel_t.t
| CHANNEL_DELETE of Channel_t.t
| CHANNEL_PINS_UPDATE of Yojson.Safe.json
| GUILD_CREATE of Guild_t.t
| GUILD_UPDATE of Guild_t.t
| GUILD_DELETE of Guild_t.t
| GUILD_BAN_ADD of Ban_t.t
| GUILD_BAN_REMOVE of Ban_t.t
| GUILD_EMOJIS_UPDATE of Yojson.Safe.json
| GUILD_INTEGRATIONS_UPDATE of Yojson.Safe.json
| GUILD_MEMBER_ADD of Member_t.t
| GUILD_MEMBER_REMOVE of Member_t.member_wrapper
| GUILD_MEMBER_UPDATE of Member_t.member_update
| GUILD_MEMBERS_CHUNK of Member_t.t list
| GUILD_ROLE_CREATE of Role_t.t
| GUILD_ROLE_UPDATE of Role_t.t
| GUILD_ROLE_DELETE of Role_t.t
| MESSAGE_CREATE of Message_t.t
| MESSAGE_UPDATE of Message_t.message_update
| MESSAGE_DELETE of Snowflake.t * Snowflake.t
| MESSAGE_BULK_DELETE of Snowflake.t list
| MESSAGE_REACTION_ADD of Reaction_t.reaction_event
| MESSAGE_REACTION_REMOVE of Reaction_t.reaction_event
| MESSAGE_REACTION_REMOVE_ALL of Reaction_t.t list
| PRESENCE_UPDATE of Presence.t
| TYPING_START of Yojson.Safe.json
| USER_UPDATE of Yojson.Safe.json
| VOICE_STATE_UPDATE of Yojson.Safe.json
| VOICE_SERVER_UPDATE of Yojson.Safe.json
| WEBHOOKS_UPDATE of Yojson.Safe.json

val event_of_yojson : contents:Yojson.Safe.json -> string -> t

val dispatch : t -> unit

val handle_event : ev:string -> Yojson.Safe.json -> unit