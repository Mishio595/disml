type t = [ `Message_id of Snowflake.t ] [@@deriving sexp, yojson { exn = true }]

val get_id : t -> Snowflake.t