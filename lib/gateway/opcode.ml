open Core

type t =
    | DISPATCH
    | HEARTBEAT
    | IDENTIFY
    | STATUS_UPDATE
    | VOICE_STATE_UPDATE
    | RESUME
    | RECONNECT
    | REQUEST_GUILD_MEMBERS
    | INVALID_SESSION
    | HELLO
    | HEARTBEAT_ACK

exception Invalid_Opcode of int

let to_int = function
    | DISPATCH -> 0
    | HEARTBEAT -> 1
    | IDENTIFY -> 2
    | STATUS_UPDATE -> 3
    | VOICE_STATE_UPDATE -> 4
    | RESUME -> 6
    | RECONNECT -> 7
    | REQUEST_GUILD_MEMBERS -> 8
    | INVALID_SESSION -> 9
    | HELLO -> 10
    | HEARTBEAT_ACK -> 11

let from_int = function
    | 0 -> DISPATCH
    | 1 -> HEARTBEAT
    | 2 -> IDENTIFY
    | 3 -> STATUS_UPDATE
    | 4 -> VOICE_STATE_UPDATE
    | 6 -> RESUME
    | 7 -> RECONNECT
    | 8 -> REQUEST_GUILD_MEMBERS
    | 9 -> INVALID_SESSION
    | 10 -> HELLO
    | 11 -> HEARTBEAT_ACK
    | op -> raise (Invalid_Opcode op)

let to_string = function
    | DISPATCH -> "DISPATCH"
    | HEARTBEAT -> "HEARTBEAT"
    | IDENTIFY -> "IDENTIFY"
    | STATUS_UPDATE -> "STATUS_UPDATE"
    | VOICE_STATE_UPDATE -> "VOICE_STATE_UPDATE"
    | RESUME -> "RESUME"
    | RECONNECT -> "RECONNECT"
    | REQUEST_GUILD_MEMBERS -> "REQUEST_GUILD_MEMBER"
    | INVALID_SESSION -> "INVALID_SESSION"
    | HELLO -> "HELLO"
    | HEARTBEAT_ACK -> "HEARTBEAT_ACK"