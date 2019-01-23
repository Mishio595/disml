type t = [ `Guild_id of Snowflake.t ] [@@deriving sexp, yojson]

let get_id (`Guild_id id) = id