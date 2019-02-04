type t = {
    id: Snowflake.t;
    filename: string;
    size: int;
    url: string;
    proxy_url: string;
    height: int;
    width: int;
} [@@deriving sexp, yojson { exn = true }]