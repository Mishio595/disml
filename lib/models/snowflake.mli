open Core

type t = Int.t [@@deriving sexp, yojson]

(** Convert a snowflake into a {!Core.Time.t} *)
val time_of_t : t -> Time.t

(** Convert a snowflake into a Unix timestamp. Millisecond precision. *)
val timestamp : t -> int

(** Convert a snowflake into an ISO8601 timestamp string. This is equivalent to calling [Snowflake.time_of_t snowflake |> Time.(to_string_iso8601_basic ~zone:Zone.utc)] *)
val timestamp_iso : t -> string