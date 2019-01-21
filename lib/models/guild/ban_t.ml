open Core

type t = {
    reason: string [@default ""];
    user: User_t.t;
} [@@deriving sexp, yojson { strict = false}]