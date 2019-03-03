let option_of_sexp = Base.Option.t_of_sexp
let sexp_of_option = Base.Option.sexp_of_t
let int_of_sexp    = Base.Int.t_of_sexp
let sexp_of_int    = Base.Int.sexp_of_t

type reaction_event = {
    user_id: User_id_t.t;
    channel_id: Channel_id_t.t;
    message_id: Message_id.t;
    guild_id: Guild_id_t.t option [@default None];
    emoji: Emoji.partial_emoji;
} [@@deriving sexp, yojson { exn = true }]

type t = {
    count: int;
    emoji: Emoji.t;
} [@@deriving sexp, yojson { strict = false; exn = true }]