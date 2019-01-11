type reaction_event = {
    user_id: Snowflake.t;
    channel_id: Snowflake.t;
    message_id: Snowflake.t;
    guild_id: Snowflake.t option [@default None];
    emoji: Emoji.partial_emoji;
} [@@deriving yojson]

type t = {
    count: int;
    emoji: Emoji.t;
} [@@deriving yojson { strict = false}]