let string_of_sexp = Base.String.t_of_sexp
let sexp_of_string = Base.String.sexp_of_t
let option_of_sexp = Base.Option.t_of_sexp
let sexp_of_option = Base.Option.sexp_of_t
let list_of_sexp   = Base.List.t_of_sexp
let sexp_of_list   = Base.List.sexp_of_t

type t = {
    user: User_t.partial_user;
    game: Activity.t option [@default None];
    status: string;
    activities: Activity.t list;
} [@@deriving sexp, yojson { strict = false; exn = true }]