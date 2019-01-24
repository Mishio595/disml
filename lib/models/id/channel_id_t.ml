type t = [ `Channel_id of Snowflake.t ] [@@deriving sexp]

let of_yojson a : (t, string) result =
    match Snowflake.of_yojson a with
    | Ok id -> Ok (`Channel_id id)
    | Error err -> Error err

let of_yojson_exn a : t = `Channel_id (Snowflake.of_yojson_exn a)
let to_yojson (`Channel_id id) = (Snowflake.to_yojson id)

let get_id (`Channel_id id) = id