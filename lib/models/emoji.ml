let string_of_sexp = Base.String.t_of_sexp
let sexp_of_string = Base.String.sexp_of_t
let option_of_sexp = Base.Option.t_of_sexp
let sexp_of_option = Base.Option.sexp_of_t
let bool_of_sexp   = Base.Bool.t_of_sexp
let sexp_of_bool   = Base.Bool.sexp_of_t
let list_of_sexp   = Base.List.t_of_sexp
let sexp_of_list   = Base.List.sexp_of_t

type partial_emoji = {
    id: Snowflake.t option [@default None];
    name: string;
} [@@deriving sexp, yojson { strict = false; exn = true }]

type t = {
    id: Snowflake.t option [@default None];
    name: string;
    roles: Role_id.t list [@default []];
    user: User_t.t option [@default None];
    require_colons: bool [@default false];
    managed: bool [@default false];
    animated: bool [@default false];
} [@@deriving sexp, yojson { strict = false; exn = true }]