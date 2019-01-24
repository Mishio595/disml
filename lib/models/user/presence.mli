type t = {
    user: User_t.partial_user;
    roles: Role_id.t list;
    game: Activity.t option;
    guild_id: Guild_id_t.t;
    status: string;
    activities: Activity.t list;
} [@@deriving sexp, yojson]