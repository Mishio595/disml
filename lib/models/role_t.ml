type role = {
    id: Snowflake.t;
    name: string;
    colour: int [@key "color"];
    hoist: bool;
    position: int;
    permissions: int;
    managed: bool;
    mentionable: bool;
} [@@deriving yojson { strict = false}]

type role_update = {
    role: role;
    guild_id: Snowflake.t;
} [@@deriving yojson { strict = false}]

type t = {
    id: Snowflake.t;
    name: string;
    colour: int [@key "color"];
    hoist: bool;
    position: int;
    permissions: int;
    managed: bool;
    mentionable: bool;
    guild_id: Snowflake.t;
} [@@deriving yojson { strict = false}]

let wrap ~guild_id ({id;name;colour;hoist;position;permissions;managed;mentionable}:role) =
    {id;name;colour;hoist;position;permissions;managed;mentionable;guild_id}