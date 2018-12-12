open Core

module Make(H : S.Handler) : S.Dispatch = struct
    type dispatch_event =
    | HELLO of Yojson.Safe.json
    | READY of Yojson.Safe.json
    | RESUMED of Yojson.Safe.json
    | INVALID_SESSION of Yojson.Safe.json
    | CHANNEL_CREATE of Channel.t
    | CHANNEL_UPDATE of Channel.t
    | CHANNEL_DELETE of Channel.t
    | CHANNEL_PINS_UPDATE of Yojson.Safe.json
    | GUILD_CREATE of Guild.t
    | GUILD_UPDATE of Guild.t
    | GUILD_DELETE of Guild.t
    | GUILD_BAN_ADD of Ban.t
    | GUILD_BAN_REMOVE of Ban.t
    | GUILD_EMOJIS_UPDATE of Yojson.Safe.json
    | GUILD_INTEGRATIONS_UPDATE of Yojson.Safe.json
    | GUILD_MEMBER_ADD of Member.t
    | GUILD_MEMBER_REMOVE of Member.t
    | GUILD_MEMBER_UPDATE of Member.t
    | GUILD_MEMBERS_CHUNK of Member.t list
    | GUILD_ROLE_CREATE of Role.t (* * Guild.t *)
    | GUILD_ROLE_UPDATE of Role.t (* * Guild.t *)
    | GUILD_ROLE_DELETE of Role.t (* * Guild.t *)
    | MESSAGE_CREATE of Message.t
    | MESSAGE_UPDATE of Message.t
    | MESSAGE_DELETE of Message.t
    | MESSAGE_BULK_DELETE of Message.t list
    | MESSAGE_REACTION_ADD of (* Message.t * *) Reaction.t
    | MESSAGE_REACTION_REMOVE of (* Message.t * *) Reaction.t
    | MESSAGE_REACTION_REMOVE_ALL of (* Message.t * *) Reaction.t list
    | PRESENCE_UPDATE of Presence.t
    | TYPING_START of Yojson.Safe.json
    | USER_UPDATE of Yojson.Safe.json
    | VOICE_STATE_UPDATE of Yojson.Safe.json
    | VOICE_SERVER_UPDATE of Yojson.Safe.json
    | WEBHOOKS_UPDATE of Yojson.Safe.json

    exception Invalid_event of string

    let event_of_string ~contents t = match t with
        | "HELLO" -> HELLO contents
        | "READY" -> READY contents
        | "RESUMED" -> RESUMED contents
        | "INVALID_SESSION" -> INVALID_SESSION contents
        | "CHANNEL_CREATE" -> CHANNEL_CREATE (Channel.of_yojson_exn contents)
        | "CHANNEL_UPDATE" -> CHANNEL_UPDATE (Channel.of_yojson_exn contents)
        | "CHANNEL_DELETE" -> CHANNEL_DELETE (Channel.of_yojson_exn contents)
        | "CHANNEL_PINS_UPDATE" -> CHANNEL_PINS_UPDATE contents
        | "GUILD_CREATE" -> GUILD_CREATE (Guild.of_yojson_exn contents)
        | "GUILD_UPDATE" -> GUILD_UPDATE (Guild.of_yojson_exn contents)
        | "GUILD_DELETE" -> GUILD_DELETE (Guild.of_yojson_exn contents)
        | "GUILD_BAN_ADD" -> GUILD_BAN_ADD (Ban.of_yojson_exn contents)
        | "GUILD_BAN_REMOVE" -> GUILD_BAN_REMOVE (Ban.of_yojson_exn contents)
        | "GUILD_EMOJIS_UPDATE" -> GUILD_EMOJIS_UPDATE contents
        | "GUILD_INTEGRATIONS_UPDATE" -> GUILD_INTEGRATIONS_UPDATE contents
        | "GUILD_MEMBER_ADD" -> GUILD_MEMBER_ADD (Member.of_yojson_exn contents)
        | "GUILD_MEMBER_REMOVE" -> GUILD_MEMBER_REMOVE (Member.of_yojson_exn contents)
        | "GUILD_MEMBER_UPDATE" -> GUILD_MEMBER_UPDATE (Member.of_yojson_exn contents)
        | "GUILD_MEMBERS_CHUNK" -> GUILD_MEMBERS_CHUNK (Yojson.Safe.Util.to_list contents |> List.map ~f:(fun m -> Member.of_yojson_exn m))
        | "GUILD_ROLE_CREATE" -> GUILD_ROLE_CREATE (Role.of_yojson_exn contents)
        | "GUILD_ROLE_UPDATE" -> GUILD_ROLE_UPDATE (Role.of_yojson_exn contents)
        | "GUILD_ROLE_DELETE" -> GUILD_ROLE_DELETE (Role.of_yojson_exn contents)
        | "MESSAGE_CREATE" -> MESSAGE_CREATE (Message.of_yojson_exn contents)
        | "MESSAGE_UPDATE" -> MESSAGE_UPDATE (Message.of_yojson_exn contents)
        | "MESSAGE_DELETE" -> MESSAGE_DELETE (Message.of_yojson_exn contents)
        | "MESSAGE_BULK_DELETE" -> MESSAGE_BULK_DELETE (Yojson.Safe.Util.to_list contents |> List.map ~f:(fun m -> Message.of_yojson_exn m))
        | "MESSAGE_REACTION_ADD" -> MESSAGE_REACTION_ADD (Reaction.of_yojson_exn contents)
        | "MESSAGE_REACTION_REMOVE" -> MESSAGE_REACTION_REMOVE (Reaction.of_yojson_exn contents)
        | "MESSAGE_REACTION_REMOVE_ALL" -> MESSAGE_REACTION_REMOVE_ALL (Yojson.Safe.Util.to_list contents |> List.map ~f:(fun r -> Reaction.of_yojson_exn r))
        | "PRESENCE_UPDATE" -> PRESENCE_UPDATE (Presence.of_yojson_exn contents)
        | "TYPING_START" -> TYPING_START contents
        | "USER_UPDATE" -> USER_UPDATE contents
        | "VOICE_STATE_UPDATE" -> VOICE_STATE_UPDATE contents
        | "VOICE_SERVER_UPDATE" -> VOICE_SERVER_UPDATE contents
        | "WEBHOOKS_UPDATE" -> WEBHOOKS_UPDATE contents
        | s -> raise (Invalid_event s)

    let dispatch ~ev contents =
        let ctx = () in
        event_of_string ~contents ev
        |> H.handle_event ctx
end