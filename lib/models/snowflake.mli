open Core

type t = Int.t [@@deriving sexp]

val of_yojson_exn : Yojson.Safe.json -> t

val of_yojson : Yojson.Safe.json -> t Ppx_deriving_yojson_runtime.error_or

val to_yojson : t -> Yojson.Safe.json

val timestamp : t -> int

val timestamp_iso : t -> string