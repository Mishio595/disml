open Core

type partial_emoji = {
    id: Snowflake.t option [@default None];
    name: string;
} [@@deriving sexp, yojson { strict = false }]

type t = {
    id: Snowflake.t option [@default None];
    name: string;
    roles: Role_id.t list [@default []];
    user: User_t.t option [@default None];
    require_colons: bool [@default false];
    managed: bool [@default false];
    animated: bool [@default false];
} [@@deriving sexp, yojson { strict = false}]