type partial_user = {
    id: Snowflake.t;
} [@@deriving yojson]

type t = {
    id: Snowflake.t;
    username: string;
    discriminator: int [@encoding `string];
    avatar: string option [@default None];
    bot: bool [@default false];
} [@@deriving yojson { strict = false }]