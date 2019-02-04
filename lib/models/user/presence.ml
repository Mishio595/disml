open Core

type t = {
    user: User_t.partial_user;
    roles: Role_id.t list;
    game: Activity.t option [@default None];
    guild_id: Guild_id_t.t;
    status: string;
    activities: Activity.t list;
} [@@deriving sexp, yojson { strict = false; exn = true }]