let string_of_sexp = Base.String.t_of_sexp
let sexp_of_string = Base.String.sexp_of_t
let option_of_sexp = Base.Option.t_of_sexp
let sexp_of_option = Base.Option.sexp_of_t
let int_of_sexp    = Base.Int.t_of_sexp
let sexp_of_int    = Base.Int.sexp_of_t

type t = {
    name: string;
    kind: int [@key "type"];
    url: string option [@default None];
} [@@deriving sexp, yojson { strict = false; exn = true }]