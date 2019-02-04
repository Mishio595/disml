(** A partial user. Used internally. *)
type partial_user = {
    id: User_id_t.t;
} [@@deriving sexp, yojson { exn = true }]

(** A user object. *)
type t = {
    id: User_id_t.t; (** The user's Snowflake ID, wrapped in the convenience [`User_id] type. *)
    username: string; (** The username of the user. *)
    discriminator: string; (** The 4 digits, as a string, that come after the '#' in a Discord username. *)
    avatar: string option; (** The hash of the user avatar, if they have one set. See {!User.face} to get the avatar URL. *)
    bot: bool; (** Whether the user is a bot. *)
} [@@deriving sexp, yojson { exn = true }]