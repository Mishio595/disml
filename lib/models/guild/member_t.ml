open Core

type partial_member = {
    nick: string option [@default None];
    roles: Role_id.t list;
    joined_at: string;
    deaf: bool;
    mute: bool;
} [@@deriving sexp, yojson { strict = false}]

type member = {
    nick: string option [@default None];
    roles: Role_id.t list;
    joined_at: string;
    deaf: bool;
    mute: bool;
    user: User_t.t;
} [@@deriving sexp, yojson { strict = false}]

type member_wrapper = {
    guild_id: Guild_id_t.t;
    user: User_t.t;
} [@@deriving sexp, yojson { strict = false }]

type member_update = {
    guild_id: Guild_id_t.t;
    roles: Role_id.t list [@default []];
    user: User_t.t;
    nick: string option [@default None];
} [@@deriving sexp, yojson { strict = false}]

type t = {
    nick: string option [@default None];
    roles: Role_id.t list;
    joined_at: string;
    deaf: bool;
    mute: bool;
    user: User_t.t;
    guild_id: Guild_id_t.t;
} [@@deriving sexp, yojson { strict = false}]

let wrap ~guild_id ({nick;roles;joined_at;deaf;mute;user}:member) =
    {nick;roles;joined_at;deaf;mute;user;guild_id = `Guild_id guild_id}