type partial_user = {
    id: Snowflake.t;
} [@@deriving sexp, yojson]

type t = {
    id: Snowflake.t;
    username: string;
    discriminator: string;
    avatar: string option;
    bot: bool;
} [@@deriving sexp, yojson]