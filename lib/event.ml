open Core

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
| GUILD_MEMBER_REMOVE of Member_t.t
| GUILD_MEMBER_UPDATE of Member_t.t
| GUILD_MEMBERS_CHUNK of Member_t.t list
| GUILD_ROLE_CREATE of Role_t.t (* * Guild_t.t *)
| GUILD_ROLE_UPDATE of Role_t.t (* * Guild_t.t *)
| GUILD_ROLE_DELETE of Role_t.t (* * Guild_t.t *)
| MESSAGE_CREATE of Message_t.t
| MESSAGE_UPDATE of Message_t.t
| MESSAGE_DELETE of Message_t.t
| MESSAGE_BULK_DELETE of Message_t.t list
| MESSAGE_REACTION_ADD of (* Message_t.t * *) Reaction_t.t
| MESSAGE_REACTION_REMOVE of (* Message_t.t * *) Reaction_t.t
| MESSAGE_REACTION_REMOVE_ALL of (* Message_t.t * *) Reaction_t.t list
| PRESENCE_UPDATE of Presence.t
| TYPING_START of Yojson.Safe.json
| USER_UPDATE of Yojson.Safe.json
| VOICE_STATE_UPDATE of Yojson.Safe.json
| VOICE_SERVER_UPDATE of Yojson.Safe.json
| WEBHOOKS_UPDATE of Yojson.Safe.json

let event_of_yojson ~contents t = match t with
    | "HELLO" -> HELLO contents
    | "READY" -> READY contents
    | "RESUMED" -> RESUMED contents
    | "INVALID_SESSION" -> INVALID_SESSION contents
    | "CHANNEL_CREATE" -> CHANNEL_CREATE (Channel_t.(channel_wrapper_of_yojson_exn contents |> wrap))
    | "CHANNEL_UPDATE" -> CHANNEL_UPDATE (Channel_t.(channel_wrapper_of_yojson_exn contents |> wrap))
    | "CHANNEL_DELETE" -> CHANNEL_DELETE (Channel_t.(channel_wrapper_of_yojson_exn contents |> wrap))
    | "CHANNEL_PINS_UPDATE" -> CHANNEL_PINS_UPDATE contents
    | "GUILD_CREATE" -> GUILD_CREATE (Guild_t.(pre_of_yojson_exn contents |> wrap))
    | "GUILD_UPDATE" -> GUILD_UPDATE (Guild_t.(pre_of_yojson_exn contents |> wrap))
    | "GUILD_DELETE" -> GUILD_DELETE (Guild_t.(pre_of_yojson_exn contents |> wrap))
    | "GUILD_BAN_ADD" -> GUILD_BAN_ADD (Ban_t.of_yojson_exn contents)
    | "GUILD_BAN_REMOVE" -> GUILD_BAN_REMOVE (Ban_t.of_yojson_exn contents)
    | "GUILD_EMOJIS_UPDATE" -> GUILD_EMOJIS_UPDATE contents
    | "GUILD_INTEGRATIONS_UPDATE" -> GUILD_INTEGRATIONS_UPDATE contents
    | "GUILD_MEMBER_ADD" -> GUILD_MEMBER_ADD (Member_t.of_yojson_exn contents)
    | "GUILD_MEMBER_REMOVE" -> GUILD_MEMBER_REMOVE (let Member_t.{guild_id;member} = Member_t.member_update_of_yojson_exn contents in Member_t.wrap ~guild_id member)
    | "GUILD_MEMBER_UPDATE" -> GUILD_MEMBER_UPDATE (let Member_t.{guild_id;member} = Member_t.member_update_of_yojson_exn contents in Member_t.wrap ~guild_id member)
    | "GUILD_MEMBERS_CHUNK" -> GUILD_MEMBERS_CHUNK (Yojson.Safe.Util.to_list contents |> List.map ~f:Member_t.of_yojson_exn)
    | "GUILD_ROLE_CREATE" -> GUILD_ROLE_CREATE (let Role_t.{guild_id;role} = Role_t.role_update_of_yojson_exn contents in Role_t.wrap ~guild_id role)
    | "GUILD_ROLE_UPDATE" -> GUILD_ROLE_UPDATE (let Role_t.{guild_id;role} = Role_t.role_update_of_yojson_exn contents in Role_t.wrap ~guild_id role)
    | "GUILD_ROLE_DELETE" -> GUILD_ROLE_DELETE (let Role_t.{guild_id;role} = Role_t.role_update_of_yojson_exn contents in Role_t.wrap ~guild_id role)
    | "MESSAGE_CREATE" -> MESSAGE_CREATE (Message_t.of_yojson_exn contents)
    | "MESSAGE_UPDATE" -> MESSAGE_UPDATE (Message_t.of_yojson_exn contents)
    | "MESSAGE_DELETE" -> MESSAGE_DELETE (Message_t.of_yojson_exn contents)
    | "MESSAGE_BULK_DELETE" -> MESSAGE_BULK_DELETE (Yojson.Safe.Util.to_list contents |> List.map ~f:Message_t.of_yojson_exn)
    | "MESSAGE_REACTION_ADD" -> MESSAGE_REACTION_ADD (Reaction_t.of_yojson_exn contents)
    | "MESSAGE_REACTION_REMOVE" -> MESSAGE_REACTION_REMOVE (Reaction_t.of_yojson_exn contents)
    | "MESSAGE_REACTION_REMOVE_ALL" -> MESSAGE_REACTION_REMOVE_ALL (Yojson.Safe.Util.to_list contents |> List.map ~f:Reaction_t.of_yojson_exn)
    | "PRESENCE_UPDATE" -> PRESENCE_UPDATE (Presence.of_yojson_exn contents)
    | "TYPING_START" -> TYPING_START contents
    | "USER_UPDATE" -> USER_UPDATE contents
    | "VOICE_STATE_UPDATE" -> VOICE_STATE_UPDATE contents
    | "VOICE_SERVER_UPDATE" -> VOICE_SERVER_UPDATE contents
    | "WEBHOOKS_UPDATE" -> WEBHOOKS_UPDATE contents
    | s -> raise (Invalid_event s)