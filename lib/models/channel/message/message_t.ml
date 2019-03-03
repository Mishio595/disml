let string_of_sexp = Base.String.t_of_sexp
let sexp_of_string = Base.String.sexp_of_t
let option_of_sexp = Base.Option.t_of_sexp
let sexp_of_option = Base.Option.sexp_of_t
let int_of_sexp    = Base.Int.t_of_sexp
let sexp_of_int    = Base.Int.sexp_of_t
let bool_of_sexp   = Base.Bool.t_of_sexp
let sexp_of_bool   = Base.Bool.sexp_of_t
let list_of_sexp   = Base.List.t_of_sexp
let sexp_of_list   = Base.List.sexp_of_t

type t = {
    id: Message_id.t;
    author: User_t.t;
    channel_id: Channel_id_t.t;
    member: Member_t.partial_member option [@default None];
    guild_id: Guild_id_t.t option [@default None];
    content: string;
    timestamp: string;
    edited_timestamp: string option [@default None];
    tts: bool;
    mention_everyone: bool;
    mentions: User_t.t list [@default []];
    mention_roles: Role_id.t list [@default []];
    attachments: Attachment.t list [@default []];
    embeds: Embed.t list [@default []];
    reactions: Reaction_t.t list [@default []];
    nonce: Snowflake.t option [@default None];
    pinned: bool;
    webhook_id: Snowflake.t option [@default None];
    kind: int [@key "type"];
} [@@deriving sexp, yojson { strict = false; exn = true }]