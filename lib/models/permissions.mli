type elt =
| CREATE_INSTANT_INVITE
| KICK_MEMBERS 
| BAN_MEMBERS 
| ADMINISTRATOR 
| MANAGE_CHANNELS 
| MANAGE_GUILD 
| ADD_REACTIONS 
| VIEW_AUDIT_LOG 
| PRIORITY_SPEAKER 
| READ_MESSAGES
| SEND_MESSAGES 
| SEND_TTS_MESSAGES 
| MANAGE_MESSAGES 
| EMBED_LINKS 
| ATTACH_FILES 
| READ_MESSAGE_HISTORY 
| MENTION_EVERYONE 
| USE_EXTERNAL_EMOJIS 
| CONNECT 
| SPEAK 
| MUTE_MEMBERS 
| DEAFEN_MEMBERS 
| MOVE_MEMBERS 
| USE_VAD 
| CHANGE_NICKNAME 
| MANAGE_NICKNAMES 
| MANAGE_ROLES 
| MANAGE_WEBHOOKS 
| MANAGE_EMOJIS
[@@deriving sexp]

include BitMaskSet.S with type elt := elt
                     with type storage = int
                     with type t = private int

val sexp_of_t : t -> Sexplib.Sexp.t
val t_of_sexp : Sexplib.Sexp.t -> t
val of_yojson_exn : Yojson.Safe.t -> t
val of_yojson : Yojson.Safe.t -> (t, string) result
val to_yojson : t -> Yojson.Safe.t