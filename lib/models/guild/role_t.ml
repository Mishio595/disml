let string_of_sexp = Base.String.t_of_sexp
let sexp_of_string = Base.String.sexp_of_t
let int_of_sexp    = Base.Int.t_of_sexp
let sexp_of_int    = Base.Int.sexp_of_t
let bool_of_sexp   = Base.Bool.t_of_sexp
let sexp_of_bool   = Base.Bool.sexp_of_t

type role = {
    id: Role_id.t;
    name: string;
    colour: int [@key "color"];
    hoist: bool;
    position: int;
    permissions: Permissions.t;
    managed: bool;
    mentionable: bool;
} [@@deriving sexp, yojson { strict = false; exn = true }]

type t = {
    id: Role_id.t;
    name: string;
    colour: int [@key "color"];
    hoist: bool;
    position: int;
    permissions: Permissions.t;
    managed: bool;
    mentionable: bool;
    guild_id: Guild_id_t.t;
} [@@deriving sexp, yojson { strict = false; exn = true }]

let wrap ~guild_id ({id;name;colour;hoist;position;permissions;managed;mentionable}:role) =
    {id;name;colour;hoist;position;permissions;managed;mentionable;guild_id = `Guild_id guild_id}