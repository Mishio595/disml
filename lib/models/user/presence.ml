open Core

type t = {
    user: User_t.partial_user;
    game: Activity.t option [@default None];
    status: string;
    activities: Activity.t list;
} [@@deriving sexp, yojson { strict = false; exn = true }]