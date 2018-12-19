open Core

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
| GUILD_ROLE_CREATE of Role_t.t (* * Guild.t *)
| GUILD_ROLE_UPDATE of Role_t.t (* * Guild.t *)
| GUILD_ROLE_DELETE of Role_t.t (* * Guild.t *)
| MESSAGE_CREATE of Message_t.t
| MESSAGE_UPDATE of Message_t.t
| MESSAGE_DELETE of Message_t.t
| MESSAGE_BULK_DELETE of Message_t.t list
| MESSAGE_REACTION_ADD of (* Message.t * *) Reaction_t.t
| MESSAGE_REACTION_REMOVE of (* Message.t * *) Reaction_t.t
| MESSAGE_REACTION_REMOVE_ALL of (* Message.t * *) Reaction_t.t list
| PRESENCE_UPDATE of Presence_t.t
| TYPING_START of Yojson.Safe.json
| USER_UPDATE of Yojson.Safe.json
| VOICE_STATE_UPDATE of Yojson.Safe.json
| VOICE_SERVER_UPDATE of Yojson.Safe.json
| WEBHOOKS_UPDATE of Yojson.Safe.json

exception Invalid_event of string

let wrap_role Role_t.{ id; role; } =
        let open Role_t in
        let guild_id = id in
        let {id;name;colour;hoist;position;permissions;managed;mentionable} = role in
        {id;name;colour;hoist;position;permissions;managed;mentionable;guild_id}

let event_of_string ~contents t = match t with
    | "HELLO" -> HELLO (Yojson.Safe.from_string contents)
    | "READY" -> READY (Yojson.Safe.from_string contents)
    | "RESUMED" -> RESUMED (Yojson.Safe.from_string contents)
    | "INVALID_SESSION" -> INVALID_SESSION (Yojson.Safe.from_string contents)
    | "CHANNEL_CREATE" -> CHANNEL_CREATE (Channel_j.t_of_string contents)
    | "CHANNEL_UPDATE" -> CHANNEL_UPDATE (Channel_j.t_of_string contents)
    | "CHANNEL_DELETE" -> CHANNEL_DELETE (Channel_j.t_of_string contents)
    | "CHANNEL_PINS_UPDATE" -> CHANNEL_PINS_UPDATE (Yojson.Safe.from_string contents)
    | "GUILD_CREATE" -> GUILD_CREATE (Guild_j.t_of_string contents)
    | "GUILD_UPDATE" -> GUILD_UPDATE (Guild_j.t_of_string contents)
    | "GUILD_DELETE" -> GUILD_DELETE (Guild_j.t_of_string contents)
    | "GUILD_BAN_ADD" -> GUILD_BAN_ADD (Ban_j.t_of_string contents)
    | "GUILD_BAN_REMOVE" -> GUILD_BAN_REMOVE (Ban_j.t_of_string contents)
    | "GUILD_EMOJIS_UPDATE" -> GUILD_EMOJIS_UPDATE (Yojson.Safe.from_string contents)
    | "GUILD_INTEGRATIONS_UPDATE" -> GUILD_INTEGRATIONS_UPDATE (Yojson.Safe.from_string contents)
    | "GUILD_MEMBER_ADD" -> GUILD_MEMBER_ADD (Member_j.t_of_string contents)
    | "GUILD_MEMBER_REMOVE" -> GUILD_MEMBER_REMOVE (Member_j.t_of_string contents)
    | "GUILD_MEMBER_UPDATE" -> GUILD_MEMBER_UPDATE (Member_j.t_of_string contents)
    | "GUILD_MEMBERS_CHUNK" -> GUILD_MEMBERS_CHUNK (Yojson.Safe.(from_string contents |> Util.to_list) |> List.map ~f:(fun m -> Yojson.Safe.to_string m |> Member_j.t_of_string))
    | "GUILD_ROLE_CREATE" -> GUILD_ROLE_CREATE (Role_j.role_update_of_string contents |> wrap_role)
    | "GUILD_ROLE_UPDATE" -> GUILD_ROLE_UPDATE (Role_j.role_update_of_string contents |> wrap_role)
    | "GUILD_ROLE_DELETE" -> GUILD_ROLE_DELETE (Role_j.role_update_of_string contents |> wrap_role)
    | "MESSAGE_CREATE" -> MESSAGE_CREATE (Message_j.t_of_string contents)
    | "MESSAGE_UPDATE" -> MESSAGE_UPDATE (Message_j.t_of_string contents)
    | "MESSAGE_DELETE" -> MESSAGE_DELETE (Message_j.t_of_string contents)
    | "MESSAGE_BULK_DELETE" -> MESSAGE_BULK_DELETE (Yojson.Safe.(from_string contents |> Util.to_list) |> List.map ~f:(fun m -> Yojson.Safe.to_string m |> Message_j.t_of_string))
    | "MESSAGE_REACTION_ADD" -> MESSAGE_REACTION_ADD (Reaction_j.t_of_string contents)
    | "MESSAGE_REACTION_REMOVE" -> MESSAGE_REACTION_REMOVE (Reaction_j.t_of_string contents)
    | "MESSAGE_REACTION_REMOVE_ALL" -> MESSAGE_REACTION_REMOVE_ALL (Yojson.Safe.(from_string contents |> Util.to_list) |> List.map ~f:(fun m -> Yojson.Safe.to_string m |> Reaction_j.t_of_string))
    | "PRESENCE_UPDATE" -> PRESENCE_UPDATE (Presence_j.t_of_string contents)
    | "TYPING_START" -> TYPING_START (Yojson.Safe.from_string contents)
    | "USER_UPDATE" -> USER_UPDATE (Yojson.Safe.from_string contents)
    | "VOICE_STATE_UPDATE" -> VOICE_STATE_UPDATE (Yojson.Safe.from_string contents)
    | "VOICE_SERVER_UPDATE" -> VOICE_SERVER_UPDATE (Yojson.Safe.from_string contents)
    | "WEBHOOKS_UPDATE" -> WEBHOOKS_UPDATE (Yojson.Safe.from_string contents)
    | s -> raise (Invalid_event s)