(** A role as Discord sends it. Only difference between this and {!t} is the lack of the guild_id field. *)
type role = {
    id: Role_id.t;
    name: string;
    colour: int;
    hoist: bool;
    position: int;
    permissions: int;
    managed: bool;
    mentionable: bool;
} [@@deriving sexp, yojson { exn = true }]

(** A role object. *)
type t = {
    id: Role_id.t; (** The role's snowflake ID. *)
    name: string; (** The role's name. *)
    colour: int; (** The integer representation of the role colour. *)
    hoist: bool; (** Whether the role is hoisted. This property controls whether the role is separated on the sidebar. *)
    position: int; (** The position of the role. [@everyone] begins the list at 0. *)
    permissions: int; (** The integer representation of the permissions the role has. *)
    managed: bool; (** Whether the guild is managed by an integration. *)
    mentionable: bool; (** Whether the role can be mentioned. *)
    guild_id: Guild_id_t.t; (** The guild ID this role belongs to. *)
} [@@deriving sexp, yojson { exn = true }]

(** Convenience method to produce {!t} from {!role} and a snowflake. *)
val wrap : guild_id:Snowflake.t -> role -> t