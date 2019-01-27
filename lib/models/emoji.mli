type partial_emoji = {
    id: Snowflake.t option;
    name: string;
} [@@deriving sexp, yojson]

type t = {
    id: Snowflake.t option;
    name: string;
    roles: Role_id.t list;
    user: User_t.t option;
    require_colons: bool option;
    managed: bool option;
    animated: bool option;
} [@@deriving sexp, yojson]