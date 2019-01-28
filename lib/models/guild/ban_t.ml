open Core

type t = {
    reason: string option [@default None];
    user: User_t.t;
} [@@deriving sexp, yojson { strict = false}]