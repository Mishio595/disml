(** Internal Opcode abstractions. *)

(** Type of known opcodes. *)
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

(** Raised when receiving an invalid opcode. This should never occur. *)
exception Invalid_Opcode of int

(** Converts an opcode to its integer form for outgoing frames. *)
val to_int : t -> int

(** Converts an integer to an opcode for incoming frames.
    Raise {!Invalid_Opcode} Raised when an unkown opcode is received.
*)
val from_int : int -> t

(** Converts and opcode to a human-readable string. Used for logging purposes. *)
val to_string : t -> string