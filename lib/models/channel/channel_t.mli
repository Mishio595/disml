exception Invalid_channel of Yojson.Safe.json

type group = {
    id: Snowflake.t;
    last_message_id: Snowflake.t option;
    last_pin_timestamp: string option;
    icon: string option;
    name: string option;
    owner_id: Snowflake.t;
    recipients: User_t.t list;
} [@@deriving sexp, yojson]

type dm = {
    id: Snowflake.t;
    last_message_id: Snowflake.t option;
    last_pin_timestamp: string option;
} [@@deriving sexp, yojson]

type guild_text = {
    id: Snowflake.t;
    last_message_id: Snowflake.t option;
    last_pin_timestamp: string option;
    category_id: Snowflake.t option;
    guild_id: Snowflake.t option;
    name: string;
    position: int;
    topic: string option;
    nsfw: bool;
    slow_mode_timeout: int option;
} [@@deriving sexp, yojson]

type guild_voice = {
    id: Snowflake.t;
    category_id: Snowflake.t option;
    guild_id: Snowflake.t option;
    name: string;
    position: int;
    user_limit: int;
    bitrate: int option;
} [@@deriving sexp, yojson]

type category = {
    id: Snowflake.t;
    guild_id: Snowflake.t option;
    position: int;
    name: string;
} [@@deriving sexp, yojson]

type t =
| Group of group
| Private of dm
| GuildText of guild_text
| GuildVoice of guild_voice
| Category of category
[@@deriving sexp, yojson]

type channel_wrapper = {
    id: Snowflake.t;
    kind: int;
    guild_id: Snowflake.t option;
    position: int option;
    name: string option;
    topic: string option;
    nsfw: bool option;
    last_message_id: Snowflake.t option;
    bitrate: int option;
    user_limit: int option;
    slow_mode_timeout: int option;
    recipients: User_t.t list option;
    icon: string option;
    owner_id: Snowflake.t option;
    application_id: Snowflake.t option;
    category_id: Snowflake.t option;
    last_pin_timestamp: string option;
} [@@deriving sexp, yojson]

val unwrap_as_guild_text : channel_wrapper -> guild_text

val unwrap_as_guild_voice : channel_wrapper -> guild_voice

val unwrap_as_dm : channel_wrapper -> dm

val unwrap_as_group : channel_wrapper -> group

val unwrap_as_category : channel_wrapper -> category

val wrap : channel_wrapper -> t

val get_id : t -> Snowflake.t