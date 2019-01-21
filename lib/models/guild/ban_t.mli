type t = {
    reason: string;
    user: User_t.t;
} [@@deriving sexp, yojson]