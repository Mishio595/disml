type partial_member = {
    nick: string option;
    roles: Role_id.t list;
    joined_at: string;
    deaf: bool;
    mute: bool;
} [@@deriving sexp, yojson { exn = true }]

type member = {
    nick: string option;
    roles: Role_id.t list;
    joined_at: string;
    deaf: bool;
    mute: bool;
    user: User_t.t;
} [@@deriving sexp, yojson { exn = true }]

type member_wrapper = {
    guild_id: Guild_id_t.t;
    user: User_t.t;
} [@@deriving sexp, yojson { exn = true }]

type member_update = {
    guild_id: Guild_id_t.t;
    roles: Role_id.t list;
    user: User_t.t;
    nick: string option;
} [@@deriving sexp, yojson { exn = true }]

(** A member object. *)
type t = {
    nick: string option; (** The nickname of the member, if they have one set. *)
    roles: Role_id.t list; (** The roles the member has. *)
    joined_at: string; (** An ISO8601 timestamp of when the user joined. *)
    deaf: bool; (** Whether the user is deafened. *)
    mute: bool; (** Whether the user is muted. *)
    user: User_t.t; (** The underlying user object for the member. *)
    guild_id: Guild_id_t.t; (** The guild ID in which the member exists. *)
} [@@deriving sexp, yojson { exn = true }]

val wrap : guild_id:Snowflake.t -> member -> t