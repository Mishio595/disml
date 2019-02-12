exception Invalid_channel of Yojson.Safe.t

(** Represents a Group channel object. *)
type group = {
    id: Channel_id_t.t;
    last_message_id: Message_id.t option;
    last_pin_timestamp: string option;
    icon: string option;
    name: string option;
    owner_id: User_id_t.t;
    recipients: User_t.t list;
} [@@deriving sexp, yojson { exn = true }]

(** Represents a private channel with a single user. *)
type dm = {
    id: Channel_id_t.t;
    last_message_id: Message_id.t option;
    last_pin_timestamp: string option;
} [@@deriving sexp, yojson { exn = true }]

(** Represents a text channel in a guild. *)
type guild_text = {
    id: Channel_id_t.t;
    last_message_id: Message_id.t option;
    last_pin_timestamp: string option;
    category_id: Channel_id_t.t option;
    guild_id: Guild_id_t.t option;
    name: string;
    position: int;
    topic: string option;
    nsfw: bool;
    slow_mode_timeout: int option;
} [@@deriving sexp, yojson { exn = true }]

(** Represents a voice channel in a guild. *)
type guild_voice = {
    id: Channel_id_t.t;
    category_id: Channel_id_t.t option;
    guild_id: Guild_id_t.t option;
    name: string;
    position: int;
    user_limit: int;
    bitrate: int option;
} [@@deriving sexp, yojson { exn = true }]

(** Represents a guild category. *)
type category = {
    id: Channel_id_t.t;
    guild_id: Guild_id_t.t option;
    position: int;
    name: string;
} [@@deriving sexp, yojson { exn = true }]

(** Wrapper variant for all channel types. *)
type t =
| Group of group
| Private of dm
| GuildText of guild_text
| GuildVoice of guild_voice
| Category of category
[@@deriving sexp, yojson { exn = true }]

(** Intermediate used internally. *)
type channel_wrapper = {
    id: Channel_id_t.t;
    kind: int;
    guild_id: Guild_id_t.t option;
    position: int option;
    name: string option;
    topic: string option;
    nsfw: bool option;
    last_message_id: Message_id.t option;
    bitrate: int option;
    user_limit: int option;
    slow_mode_timeout: int option;
    recipients: User_t.t list option;
    icon: string option;
    owner_id: User_id_t.t option;
    application_id: Snowflake.t option;
    category_id: Channel_id_t.t option;
    last_pin_timestamp: string option;
} [@@deriving sexp, yojson { exn = true }]

val unwrap_as_guild_text : channel_wrapper -> guild_text

val unwrap_as_guild_voice : channel_wrapper -> guild_voice

val unwrap_as_dm : channel_wrapper -> dm

val unwrap_as_group : channel_wrapper -> group

val unwrap_as_category : channel_wrapper -> category

val wrap : channel_wrapper -> t

val get_id : t -> Snowflake.t