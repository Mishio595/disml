open Core

type t = {
    id: Snowflake.t;
    filename: string;
    size: int;
    url: string;
    proxy_url: string;
    height: int [@default -1];
    width: int [@default -1];
} [@@deriving sexp, yojson { strict = false}]