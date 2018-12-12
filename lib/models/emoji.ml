type t = {
    id: Snowflake.t;
    name: string;
    roles: (Role.t list) option;
    user: User.t option;
    require_colons: bool option;
    managed: bool;
    animated: bool;
} [@@deriving yojson]