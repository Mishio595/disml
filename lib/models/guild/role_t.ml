open Core

type role = {
    id: Role_id.t;
    name: string;
    colour: int [@key "color"];
    hoist: bool;
    position: int;
    permissions: int;
    managed: bool;
    mentionable: bool;
} [@@deriving sexp, yojson { strict = false; exn = true }]

type t = {
    id: Role_id.t;
    name: string;
    colour: int [@key "color"];
    hoist: bool;
    position: int;
    permissions: int;
    managed: bool;
    mentionable: bool;
    guild_id: Guild_id_t.t;
} [@@deriving sexp, yojson { strict = false; exn = true }]

let wrap ~guild_id ({id;name;colour;hoist;position;permissions;managed;mentionable}:role) =
    {id;name;colour;hoist;position;permissions;managed;mentionable;guild_id = `Guild_id guild_id}