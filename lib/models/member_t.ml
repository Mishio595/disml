type partial_member = {
    nick: string option [@default None];
    roles: Snowflake.t list;
    joined_at: string;
    deaf: bool;
    mute: bool;
} [@@deriving yojson]

type member = {
    nick: string option [@default None];
    roles: Snowflake.t list;
    joined_at: string;
    deaf: bool;
    mute: bool;
    user: User_t.t;
} [@@deriving yojson]

type member_update = {
    guild_id: Snowflake.t [@key "id"];
    member: member;
} [@@deriving yojson]

type t = {
    nick: string option [@default None];
    roles: Snowflake.t list;
    joined_at: string;
    deaf: bool;
    mute: bool;
    user: User_t.t;
    guild_id: Snowflake.t;
} [@@deriving yojson]

let wrap ~guild_id ({nick;roles;joined_at;deaf;mute;user}:member) =
    {nick;roles;joined_at;deaf;mute;user;guild_id}