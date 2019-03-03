let string_of_sexp = Base.String.t_of_sexp
let sexp_of_string = Base.String.sexp_of_t
let option_of_sexp = Base.Option.t_of_sexp
let sexp_of_option = Base.Option.sexp_of_t
let bool_of_sexp   = Base.Bool.t_of_sexp
let sexp_of_bool   = Base.Bool.sexp_of_t

type partial_user = {
    id: User_id_t.t;
    username: string option [@default None];
    discriminator: string option [@default None];
    avatar: string option [@default None];
    bot: bool [@default false];
} [@@deriving sexp, yojson { strict = false; exn = true }]

type t = {
    id: User_id_t.t;
    username: string;
    discriminator: string;
    avatar: string option [@default None];
    bot: bool [@default false];
} [@@deriving sexp, yojson { strict = false; exn = true }]