type role = {
    id: Snowflake.t;
    name: string;
    colour: int;
    hoist: bool;
    position: int;
    permissions: int;
    managed: bool;
    mentionable: bool;
} [@@deriving sexp, yojson]

type t = {
    id: Snowflake.t;
    name: string;
    colour: int;
    hoist: bool;
    position: int;
    permissions: int;
    managed: bool;
    mentionable: bool;
    guild_id: Snowflake.t;
} [@@deriving sexp, yojson]

val wrap : guild_id:Snowflake.t -> role -> t