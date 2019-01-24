type t = [ `User_id of Snowflake.t ] [@@deriving sexp, yojson]

let get_id (`User_id id) = id