open Core

type partial_user = {
    id: User_id_t.t;
} [@@deriving sexp, yojson { strict = false; exn = true }]

type t = {
    id: User_id_t.t;
    username: string;
    discriminator: string;
    avatar: string option [@default None];
    bot: bool [@default false];
} [@@deriving sexp, yojson { strict = false; exn = true }]