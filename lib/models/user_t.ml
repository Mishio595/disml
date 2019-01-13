open Core

type partial_user = {
    id: Snowflake.t;
} [@@deriving sexp, yojson { strict = false}]

type t = {
    id: Snowflake.t;
    username: string;
    discriminator: string;
    avatar: string option [@default None];
    bot: bool [@default false];
} [@@deriving sexp, yojson { strict = false }]