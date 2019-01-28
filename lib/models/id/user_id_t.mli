type t = [ `User_id of Snowflake.t ] [@@deriving sexp, yojson]

val get_id : t -> Snowflake.t