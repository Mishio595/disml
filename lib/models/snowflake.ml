open Core

type t = Int.t [@@deriving sexp]

let of_yojson_exn d = Yojson.Safe.Util.to_string d |> Int.of_string

let of_yojson d =
    try of_yojson_exn d |> Ok
    with Yojson.Safe.Util.Type_error (why,_) -> Error why

let to_yojson s : Yojson.Safe.json = `String (Int.to_string s)

let timestamp snowflake = (snowflake lsr 22) + 1_420_070_400_000

let timestamp_iso snowflake =
    let t = timestamp snowflake |> float_of_int in
    Time.(Span.of_ms t
    |> of_span_since_epoch
    |> to_string_iso8601_basic ~zone:Zone.utc)