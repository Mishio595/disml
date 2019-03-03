let string_of_sexp = Base.String.t_of_sexp
let sexp_of_string = Base.String.sexp_of_t
let option_of_sexp = Base.Option.t_of_sexp
let sexp_of_option = Base.Option.sexp_of_t

type t = {
    reason: string option [@default None];
    user: User_t.t;
} [@@deriving sexp, yojson { strict = false; exn = true }]