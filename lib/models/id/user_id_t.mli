type t = [ `User_id of Snowflake.t ] [@@deriving sexp, yojson { exn = true }]

val compare : t -> t -> int
val get_id : t -> Snowflake.t