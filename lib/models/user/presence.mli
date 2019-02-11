(** A user presence. *)
type t = {
    user: User_t.partial_user; (** A partial user that this presence belongs to. *)
    game: Activity.t option; (** The current activity of the user, if any. *)
    status: string; (** One of [online], [idle], [offline], or [dnd]. *)
    activities: Activity.t list; (** A list of all of the user's current activities. *)
} [@@deriving sexp, yojson { exn = true }]