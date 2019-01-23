type t = [ `Channel_id of Snowflake.t ] [@@deriving sexp, yojson]

let get_id (`Channel_id id) = id