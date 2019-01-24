type t = [ `Role_id of Snowflake.t ] [@@deriving sexp, yojson]

let get_id (`Role_id id) = id