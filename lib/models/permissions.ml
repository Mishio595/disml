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

include BitMaskSet.Make(struct
    include BitMaskSet.Int
    type t = elt
    let mask = 0b0111_1111_1111_0111_1111_1101_1111_1111
end)

let sexp_of_t = Core.Int.sexp_of_t
let t_of_sexp = Core.Int.t_of_sexp

let of_yojson_exn j = create @@ Yojson.Safe.Util.to_int j

let of_yojson j =
    try Ok (of_yojson_exn j)
    with Yojson.Safe.Util.Type_error (why,_) -> Error why

let to_yojson t : Yojson.Safe.t = `Int t

let of_seq seq = List.of_seq seq |> of_list

let to_seq mask = elements mask |> List.to_seq

let to_seq_from elt init =
    let _, _, r = split elt init in
    elt :: elements r |> List.to_seq

let add_seq seq init =
    List.of_seq seq
    |> of_list
    |> (lor) init