open Core

type t = Int.t [@@deriving sexp, yojson]

val timestamp : t -> int
val timestamp_iso : t -> string