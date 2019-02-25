open Core

type t =
{ id: Snowflake.t
; kind: string [@key "type"]
; allow: Permissions.t
; deny: Permissions.t
} [@@deriving sexp, yojson { strict = false; exn = true }]