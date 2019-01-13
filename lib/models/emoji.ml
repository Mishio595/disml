open Core

type partial_emoji = {
    id: Snowflake.t option [@default None];
    name: string;
} [@@deriving sexp, yojson { strict = false }]

type t = {
    id: Snowflake.t option [@default None];
    name: string;
    roles: Snowflake.t list [@default []];
    user: User_t.t option [@default None];
    require_colons: bool option [@default None];
    managed: bool option [@default None];
    animated: bool option [@default None];
} [@@deriving sexp, yojson { strict = false}]