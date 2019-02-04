open Core

exception Invalid_channel of Yojson.Safe.t

type group = {
    id: Channel_id_t.t;
    last_message_id: Message_id.t option [@default None];
    last_pin_timestamp: string option [@default None];
    icon: string option [@default None];
    name: string option [@default None];
    owner_id: User_id_t.t;
    recipients: User_t.t list [@default []];
} [@@deriving sexp, yojson { strict = false; exn = true }]

type dm = {
    id: Channel_id_t.t;
    last_message_id: Message_id.t option [@default None];
    last_pin_timestamp: string option [@default None];
} [@@deriving sexp, yojson { strict = false; exn = true }]

type guild_text = {
    id: Channel_id_t.t;
    last_message_id: Message_id.t option [@default None];
    last_pin_timestamp: string option [@default None];
    category_id: Channel_id_t.t option [@default None][@key "parent_id"];
    guild_id: Guild_id_t.t option [@default None];
    name: string;
    position: int;
    topic: string option [@default None];
    nsfw: bool;
    slow_mode_timeout: int option [@default None];
} [@@deriving sexp, yojson { strict = false; exn = true }]

type guild_voice = {
    id: Channel_id_t.t;
    category_id: Channel_id_t.t option [@default None][@key "parent_id"];
    guild_id: Guild_id_t.t option [@default None];
    name: string;
    position: int;
    user_limit: int [@default -1];
    bitrate: int option [@default None];
} [@@deriving sexp, yojson { strict = false; exn = true }]

type category = {
    id: Channel_id_t.t;
    guild_id: Guild_id_t.t option [@default None];
    position: int;
    name: string;
} [@@deriving sexp, yojson { strict = false; exn = true }]

type t =
| Group of group
| Private of dm
| GuildText of guild_text
| GuildVoice of guild_voice
| Category of category
[@@deriving sexp, yojson { strict = false; exn = true }]

type channel_wrapper = {
    id: Channel_id_t.t;
    kind: int [@key "type"];
    guild_id: Guild_id_t.t option [@default None];
    position: int option [@default None];
    name: string option [@default None];
    topic: string option [@default None];
    nsfw: bool option [@default None];
    last_message_id: Message_id.t option [@default None];
    bitrate: int option [@default None];
    user_limit: int option [@default None];
    slow_mode_timeout: int option [@default None];
    recipients: User_t.t list option [@default None];
    icon: string option [@default None];
    owner_id: User_id_t.t option [@default None];
    application_id: Snowflake.t option [@default None];
    category_id: Channel_id_t.t option [@default None][@key "parent_id"];
    last_pin_timestamp: string option [@default None];
} [@@deriving sexp, yojson { strict = false; exn = true }]

let unwrap_as_guild_text {id;guild_id;position;name;topic;nsfw;last_message_id;slow_mode_timeout;category_id;last_pin_timestamp;_} =
    let position = Option.value_exn position in
    let name = Option.value_exn name in
    let nsfw = Option.value ~default:false nsfw in
    { id; guild_id; position; name; topic; nsfw; last_message_id; slow_mode_timeout; category_id; last_pin_timestamp }

let unwrap_as_guild_voice {id;guild_id;position;name;bitrate;user_limit;category_id;_} =
    let position = Option.value_exn position in
    let name = Option.value_exn name in
    let user_limit = Option.value ~default:(-1) user_limit in
    { id; guild_id; position; name; user_limit; bitrate ; category_id; }

let unwrap_as_dm {id;last_message_id;last_pin_timestamp;_} =
    { id; last_message_id; last_pin_timestamp; }

let unwrap_as_group {id;name;last_message_id;recipients;icon;owner_id;last_pin_timestamp;_} =
    let recipients = Option.value ~default:[] recipients in
    let owner_id = Option.value_exn owner_id in
    { id; name; last_message_id; recipients; icon; owner_id; last_pin_timestamp; }

let unwrap_as_category {id;guild_id;position;name;_} =
    let position = Option.value_exn position in
    let name = Option.value_exn name in
    { id; guild_id; position; name; }

let wrap s =
    match s.kind with
    | 0 -> GuildText (unwrap_as_guild_text s)
    | 1 -> Private (unwrap_as_dm s)
    | 2 -> GuildVoice (unwrap_as_guild_voice s)
    | 3 -> Group (unwrap_as_group s)
    | 4 -> Category (unwrap_as_category s)
    | _ -> raise (Invalid_channel (channel_wrapper_to_yojson s))

let get_id = function
| Group g -> let `Channel_id id = g.id in id
| Private p -> let `Channel_id id = p.id in id
| GuildText t -> let `Channel_id id = t.id in id
| GuildVoice v -> let `Channel_id id = v.id in id
| Category c -> let `Channel_id id = c.id in id