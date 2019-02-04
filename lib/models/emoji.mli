(** A partial emoji, used internally. *)
type partial_emoji = {
    id: Snowflake.t option;
    name: string;
} [@@deriving sexp, yojson { exn = true }]

(** A full emoji object. *)
type t = {
    id: Snowflake.t option; (** Snowflake ID of the emoji. Only exists for custom emojis. *)
    name: string; (** Name of the emoji. Either the emoji custom name or a unicode character. *)
    roles: Role_id.t list;  (** List of roles required to use this emoji. Is only non-empty on some integration emojis. *)
    user: User_t.t option;  (** User object of the person who uploaded the emoji. Only exists for custom emojis. *)
    require_colons: bool; (** Whether the emoji must be wrapped in colons. Is false for unicode emojis. *)
    managed: bool; (** Whether the emoji is managed by an integration. *)
    animated: bool; (** Whether the emoji is animated. *)
} [@@deriving sexp, yojson { exn = true }]