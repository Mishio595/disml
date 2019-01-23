(** Represents a single reaction as received over the gateway. *)
type reaction_event = {
    user_id: Snowflake.t;
    channel_id: Snowflake.t;
    message_id: Snowflake.t;
    guild_id: Snowflake.t option;
    emoji: Emoji.partial_emoji;
} [@@deriving sexp, yojson]

(** Represents a number of emojis used as a reaction on a message. *)
type t = {
    count: int;
    emoji: Emoji.t;
} [@@deriving sexp, yojson]