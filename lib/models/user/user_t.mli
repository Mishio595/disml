type partial_user = {
    id: User_id_t.t;
} [@@deriving sexp, yojson]

type t = {
    id: User_id_t.t;
    username: string;
    discriminator: string;
    avatar: string option;
    bot: bool;
} [@@deriving sexp, yojson]