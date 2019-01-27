open Core

type reaction_event = {
    user_id: User_id_t.t;
    channel_id: Channel_id_t.t;
    message_id: Message_id.t;
    guild_id: Guild_id_t.t option [@default None];
    emoji: Emoji.partial_emoji;
} [@@deriving sexp, yojson]

type t = {
    count: int;
    emoji: Emoji.t;
} [@@deriving sexp, yojson { strict = false}]