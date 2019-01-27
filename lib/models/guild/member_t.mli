type partial_member = {
    nick: string option;
    roles: Role_id.t list;
    joined_at: string;
    deaf: bool;
    mute: bool;
} [@@deriving sexp, yojson]

type member = {
    nick: string option;
    roles: Role_id.t list;
    joined_at: string;
    deaf: bool;
    mute: bool;
    user: User_t.t;
} [@@deriving sexp, yojson]

type member_wrapper = {
    guild_id: Guild_id_t.t;
    user: User_t.t;
} [@@deriving sexp, yojson]

type member_update = {
    guild_id: Guild_id_t.t;
    roles: Role_id.t list;
    user: User_t.t;
    nick: string option;
} [@@deriving sexp, yojson]

type t = {
    nick: string option;
    roles: Role_id.t list;
    joined_at: string;
    deaf: bool;
    mute: bool;
    user: User_t.t;
    guild_id: Guild_id_t.t;
} [@@deriving sexp, yojson]

val wrap : guild_id:Snowflake.t -> member -> t