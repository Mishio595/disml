type t = {
    user: User_t.partial_user;
    roles: Snowflake.t list;
    game: Activity.t option;
    guild_id: Snowflake.t;
    status: string;
    activities: Activity.t list;
} [@@deriving sexp, yojson]