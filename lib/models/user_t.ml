type partial_user = {
    id: Snowflake.t;
} [@@deriving yojson { strict = false}]

type t = {
    id: Snowflake.t;
    username: string;
    discriminator: string;
    avatar: string option [@default None];
    bot: bool [@default false];
} [@@deriving yojson { strict = false }]