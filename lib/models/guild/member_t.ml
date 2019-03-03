let string_of_sexp = Base.String.t_of_sexp
let sexp_of_string = Base.String.sexp_of_t
let option_of_sexp = Base.Option.t_of_sexp
let sexp_of_option = Base.Option.sexp_of_t
let bool_of_sexp   = Base.Bool.t_of_sexp
let sexp_of_bool   = Base.Bool.sexp_of_t
let list_of_sexp   = Base.List.t_of_sexp
let sexp_of_list   = Base.List.sexp_of_t

type partial_member = {
    nick: string option [@default None];
    roles: Role_id.t list;
    joined_at: string;
    deaf: bool;
    mute: bool;
} [@@deriving sexp, yojson { strict = false; exn = true }]

type member = {
    nick: string option [@default None];
    roles: Role_id.t list;
    joined_at: string;
    deaf: bool;
    mute: bool;
    user: User_t.t;
} [@@deriving sexp, yojson { strict = false; exn = true }]

type member_wrapper = {
    guild_id: Guild_id_t.t;
    user: User_t.t;
} [@@deriving sexp, yojson { strict = false; exn = true }]

type member_update = {
    guild_id: Guild_id_t.t;
    roles: Role_id.t list [@default []];
    user: User_t.t;
    nick: string option [@default None];
} [@@deriving sexp, yojson { strict = false; exn = true }]

type t = {
    nick: string option [@default None];
    roles: Role_id.t list;
    joined_at: string;
    deaf: bool;
    mute: bool;
    user: User_t.t;
    guild_id: Guild_id_t.t;
} [@@deriving sexp, yojson { strict = false; exn = true }]

let wrap ~guild_id ({nick;roles;joined_at;deaf;mute;user}:member) =
    {nick;roles;joined_at;deaf;mute;user;guild_id = `Guild_id guild_id}