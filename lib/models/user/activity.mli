(** An activity object. *)
type t = {
    name: string; (** The name of the activity. *)
    kind: int; (** 0 = Playing, 1 = Streaming, 2 = Listening, 3 = Watching *)
    url: string option; (** Stream URL. Only validated for kind = 1. *)
} [@@deriving sexp, yojson { exn = true }]