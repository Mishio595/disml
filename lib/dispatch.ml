(* open Async *)

type dispatch_event =
| HELLO of Yojson.Basic.json
| READY of Yojson.Basic.json
| RESUMED of Yojson.Basic.json
| INVALID_SESSION of Yojson.Basic.json
| CHANNEL_CREATE of Channel.t
| CHANNEL_UPDATE of Channel.t
| CHANNEL_DELETE of Channel.t
| CHANNEL_PINS_UPDATE of Yojson.Basic.json
| GUILD_CREATE of Guild.t
| GUILD_UPDATE of Guild.t
| GUILD_DELETE of Guild.t
| GUILD_BAN_ADD of Ban.t
| GUILD_BAN_REMOVE of Ban.t
| GUILD_EMOJIS_UPDATE of Yojson.Basic.json
| GUILD_INTEGRATIONS_UPDATE of Yojson.Basic.json
| GUILD_MEMBER_ADD of Member.t
| GUILD_MEMBER_REMOVE of Member.t
| GUILD_MEMBER_UPDATE of Member.t
| GUILD_MEMBERS_CHUNK of Member.t list
| GUILD_ROLE_CREATE of Role.t * Guild.t
| GUILD_ROLE_UPDATE of Role.t * Guild.t
| GUILD_ROLE_DELETE of Role.t * Guild.t
| MESSAGE_CREATE of Message.t
| MESSAGE_UPDATE of Message.t
| MESSAGE_DELETE of Message.t
| MESSAGE_BULK_DELETE of Message.t list
| MESSAGE_REACTION_ADD of Message.t * Reaction.t
| MESSAGE_REACTION_REMOVE of Message.t * Reaction.t
| MESSAGE_REACTION_REMOVE_ALL of Message.t * Reaction.t list
| PRESENCE_UPDATE of Presence.t
| TYPING_START of Yojson.Basic.json
| USER_UPDATE of Yojson.Basic.json
| VOICE_STATE_UPDATE of Yojson.Basic.json
| VOICE_SERVER_UPDATE of Yojson.Basic.json
| WEBHOOKS_UPDATE of Yojson.Basic.json
