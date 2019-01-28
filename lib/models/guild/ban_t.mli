type t = {
    reason: string option; (** The reason for the ban. *)
    user: User_t.t; (** The banned user. *)
} [@@deriving sexp, yojson]