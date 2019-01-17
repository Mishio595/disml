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

val to_int : t -> int
val from_int : int -> t
val to_string : t -> string