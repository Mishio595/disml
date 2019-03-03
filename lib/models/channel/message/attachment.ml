let string_of_sexp = Base.String.t_of_sexp
let sexp_of_string = Base.String.sexp_of_t
let int_of_sexp    = Base.Int.t_of_sexp
let sexp_of_int    = Base.Int.sexp_of_t

type t = {
    id: Snowflake.t;
    filename: string;
    size: int;
    url: string;
    proxy_url: string;
    height: int [@default -1];
    width: int [@default -1];
} [@@deriving sexp, yojson { strict = false; exn = true }]