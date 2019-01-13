open Core

type t = Int.t [@@deriving sexp]

let of_yojson_exn d = Yojson.Safe.Util.to_string d |> Int.of_string

let of_yojson d =
    try of_yojson_exn d |> Ok
    with Yojson.Safe.Util.Type_error (why,_) -> Error why

let to_yojson s : Yojson.Safe.json = `String (Int.to_string s)

let timestamp snowflake =
    let offset = (snowflake lsr 22) / 1000 in
    1_420_070_400 + offset

let timestamp_iso snowflake =
    let t = timestamp snowflake in
    Date.(
        of_time ~zone:Time.Zone.utc
        Time.(of_span_since_epoch @@ Span.of_int_sec t)
    |> format) "%FT%T+00:00"