type t =
{ id: Snowflake.t
; kind: string
; allow: Permissions.t
; deny: Permissions.t
} [@@deriving sexp, yojson { exn = true }]