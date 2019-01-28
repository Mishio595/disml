(** A user presence. *)
type t = {
    user: User_t.partial_user; (** A partial user that this presence belongs to. *)
    roles: Role_id.t list; (** A list of roles that the user has. *)
    game: Activity.t option; (** The current activity of the user, if any. *)
    guild_id: Guild_id_t.t; (** The guild ID in which this presence exists. *)
    status: string; (** One of [online], [idle], [offline], or [dnd]. *)
    activities: Activity.t list; (** A list of all of the user's current activities. *)
} [@@deriving sexp, yojson]