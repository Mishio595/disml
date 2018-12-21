module Make(Models : Disml.S.Models) = struct
    open Core
    open Async
    open Models
    open Disml.Event

    let check_command (msg:Disml.Message_t.t) =
        if String.is_prefix ~prefix:"!ping" msg.content then
            Message.reply msg "Pong!" >>> ignore
        else if String.is_prefix ~prefix:"!spam" msg.content then
            List.range 0 20
            |> List.iter ~f:(fun i -> Message.reply msg (string_of_int i) >>> ignore)
        else if String.is_prefix ~prefix:"!list" msg.content then
            let count = String.chop_prefix_exn ~prefix:"!list" msg.content |> String.strip |> Int.of_string in
            let list = List.range 0 count
            |> List.sexp_of_t Int.sexp_of_t
            |> Sexp.to_string_hum in
            Message.reply msg list >>> ignore
        else if String.is_prefix ~prefix:"!fold" msg.content then
            let count = String.chop_prefix_exn ~prefix:"!fold" msg.content |> String.strip |> Int.of_string in
            let list = List.range 0 count
            |> List.fold ~init:0 ~f:(+)
            |> Int.to_string in
            Message.reply msg list >>> ignore

    let handle_event = function
    | HELLO _ -> print_endline "Received HELLO" 
    | READY _ -> print_endline "Received READY" 
    | RESUMED _ -> print_endline "Received RESUMED" 
    | INVALID_SESSION _ -> print_endline "Received INVALID_SESSION" 
    | CHANNEL_CREATE _ -> print_endline "Received CHANNEL_CREATE" 
    | CHANNEL_UPDATE _ -> print_endline "Received CHANNEL_UPDATE" 
    | CHANNEL_DELETE _ -> print_endline "Received CHANNEL_DELETE" 
    | CHANNEL_PINS_UPDATE _ -> print_endline "Received CHANNEL_PINS_UPDATE" 
    | GUILD_CREATE _ -> print_endline "Received GUILD_CREATE" 
    | GUILD_UPDATE _ -> print_endline "Received GUILD_UPDATE" 
    | GUILD_DELETE _ -> print_endline "Received GUILD_DELETE" 
    | GUILD_BAN_ADD _ -> print_endline "Received GUILD_BAN_ADD" 
    | GUILD_BAN_REMOVE _ -> print_endline "Received GUILD_BAN_REMOVE" 
    | GUILD_EMOJIS_UPDATE _ -> print_endline "Received GUILD_EMOJIS_UPDATE" 
    | GUILD_INTEGRATIONS_UPDATE _ -> print_endline "Received GUILD_INTEGRATIONS_UPDATE" 
    | GUILD_MEMBER_ADD _ -> print_endline "Received GUILD_MEMBER_ADD" 
    | GUILD_MEMBER_REMOVE _ -> print_endline "Received GUILD_MEMBER_REMOVE" 
    | GUILD_MEMBER_UPDATE _ -> print_endline "Received GUILD_MEMBER_UPDATE" 
    | GUILD_MEMBERS_CHUNK _ -> print_endline "Received GUILD_MEMBERS_CHUNK" 
    | GUILD_ROLE_CREATE _ -> print_endline "Received GUILD_ROLE_CREATE" 
    | GUILD_ROLE_UPDATE _ -> print_endline "Received GUILD_ROLE_UPDATE" 
    | GUILD_ROLE_DELETE _ -> print_endline "Received GUILD_ROLE_DELETE" 
    | MESSAGE_CREATE msg -> check_command msg; print_endline "Received MESSAGE_CREATE" 
    | MESSAGE_UPDATE _ -> print_endline "Received MESSAGE_UPDATE" 
    | MESSAGE_DELETE _ -> print_endline "Received MESSAGE_DELETE" 
    | MESSAGE_BULK_DELETE _ -> print_endline "Received MESSAGE_BULK_DELETE" 
    | MESSAGE_REACTION_ADD _ -> print_endline "Received MESSAGE_REACTION_ADD" 
    | MESSAGE_REACTION_REMOVE _ -> print_endline "Received MESSAGE_REACTION_REMOVE" 
    | MESSAGE_REACTION_REMOVE_ALL _ -> print_endline "Received MESSAGE_REACTION_REMOVE_ALL" 
    | PRESENCE_UPDATE _ -> print_endline "Received PRESENCE_UPDATE" 
    | TYPING_START _ -> print_endline "Received TYPING_START" 
    | USER_UPDATE _ -> print_endline "Received USER_UPDATE" 
    | VOICE_STATE_UPDATE _ -> print_endline "Received VOICE_STATE_UPDATE" 
    | VOICE_SERVER_UPDATE _ -> print_endline "Received VOICE_SERVER_UPDATE" 
    | WEBHOOKS_UPDATE _ -> print_endline "Received WEBHOOKS_UPDATE"
end