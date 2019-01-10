open Core

type t = int [@@deriving yojson]

let timestamp snowflake =
    let offset = (snowflake lsr 22) / 1000 in
    1_420_070_400 + offset

let timestamp_iso snowflake =
    let t = timestamp snowflake in
    Date.(
        of_time ~zone:Time.Zone.utc
        Time.(of_span_since_epoch @@ Span.of_int_sec t)
    |> format) "%FT%T+00:00"