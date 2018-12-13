type t = {
    id: Snowflake.t;
    username: string;
    discriminator: string;
    avatar: string;
    bot: bool;
} [@@deriving yojson]