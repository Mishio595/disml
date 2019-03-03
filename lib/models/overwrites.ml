let string_of_sexp = Base.String.t_of_sexp
let sexp_of_string = Base.String.sexp_of_t

type t =
{ id: Snowflake.t
; kind: string [@key "type"]
; allow: Permissions.t
; deny: Permissions.t
} [@@deriving sexp, yojson { strict = false; exn = true }]