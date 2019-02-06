open Core

type unavailable = {
    id: Guild_id_t.t;
    unavailable: bool;
} [@@deriving sexp, yojson { strict = false; exn = true }]

type pre = {
    id: Guild_id_t.t;
    name: string;
    icon: string option [@default None];
    splash: string option [@default None];
    owner_id: User_id_t.t;
    region: string;
    afk_channel_id: Channel_id_t.t option [@default None];
    afk_timeout: int;
    embed_enabled: bool [@default false];
    embed_channel_id: Channel_id_t.t option [@default None];
    verification_level: int;
    default_message_notifications: int;
    explicit_content_filter: int;
    roles: Role_t.role list;
    emojis: Emoji.t list;
    features: string list;
    mfa_level: int;
    application_id: Snowflake.t option [@default None];
    widget_enabled: bool [@default false];
    widget_channel_id: Channel_id_t.t option [@default None];
    system_channel_id: Channel_id_t.t option [@default None];
    large: bool;
    member_count: int option [@default None];
    members: Member_t.member list;
    channels: Channel_t.channel_wrapper list;
} [@@deriving sexp, yojson { strict = false; exn = true }]

type t = {
    id: Guild_id_t.t;
    name: string;
    icon: string option [@default None];
    splash: string option [@default None];
    owner_id: User_id_t.t;
    region: string;
    afk_channel_id: Channel_id_t.t option [@default None];
    afk_timeout: int;
    embed_enabled: bool [@default false];
    embed_channel_id: Channel_id_t.t option [@default None];
    verification_level: int;
    default_message_notifications: int;
    explicit_content_filter: int;
    roles: Role_t.t list;
    emojis: Emoji.t list;
    features: string list;
    mfa_level: int;
    application_id: Snowflake.t option [@default None];
    widget_enabled: bool [@default false];
    widget_channel_id: Channel_id_t.t option [@default None];
    system_channel_id: Channel_id_t.t option [@default None];
    large: bool;
    member_count: int option [@default None];
    members: Member_t.t list;
    channels: Channel_t.t list;
} [@@deriving sexp, yojson { strict = false; exn = true }]

let wrap ({id;name;icon;splash;owner_id;region;afk_channel_id;afk_timeout;embed_enabled;embed_channel_id;verification_level;default_message_notifications;explicit_content_filter;roles;emojis;features;mfa_level;application_id;widget_enabled;widget_channel_id;system_channel_id;large;member_count;members;channels}:pre) =
    let `Guild_id id = id in
    let roles = List.map ~f:(Role_t.wrap ~guild_id:id) roles in
    let members = List.map ~f:(Member_t.wrap ~guild_id:id) members in
    let channels = List.map ~f:Channel_t.wrap channels in
    {id = `Guild_id id;name;icon;splash;owner_id;region;afk_channel_id;afk_timeout;embed_enabled;embed_channel_id;verification_level;default_message_notifications;explicit_content_filter;roles;emojis;features;mfa_level;application_id;widget_enabled;widget_channel_id;system_channel_id;large;member_count;members;channels}

let get_id guild = let `Guild_id id = guild.id in id