type t = {
    id: Snowflake.t;
    name: string;
    colour: int;
    hoist: bool;
    position: int;
    permissions: int;
    managed: bool;
    mentionable: bool;
} [@@deriving yojson]