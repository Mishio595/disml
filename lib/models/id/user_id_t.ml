type t = [ `User_id of Snowflake.t ] [@@deriving sexp]

let of_yojson a : (t, string) result =
    match Snowflake.of_yojson a with
    | Ok id -> Ok (`User_id id)
    | Error err -> Error err

let of_yojson_exn a : t = `User_id (Snowflake.of_yojson_exn a)
let to_yojson (`User_id id) = (Snowflake.to_yojson id)

let get_id (`User_id id) = id