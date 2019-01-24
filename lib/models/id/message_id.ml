type t = [ `Message_id of Snowflake.t ] [@@deriving sexp, yojson]

let get_id (`Message_id id) = id