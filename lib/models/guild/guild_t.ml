open Core

type unavailable = {
    id: Guild_id_t.t;
} [@@deriving sexp, yojson]

type pre = {
    id: Snowflake.t;
    name: string;
    icon: string option [@default None];
    splash: string option [@default None];
    owner_id: Snowflake.t;
    region: string;
    afk_channel_id: Snowflake.t option [@default None];
    afk_timeout: int;
    embed_enabled: bool option [@default None];
    embed_channel_id: Snowflake.t option [@default None];
    verification_level: int;
    default_message_notifications: int;
    explicit_content_filter: int;
    roles: Role_t.role list;
    emojis: Emoji.t list;
    features: string list;
    mfa_level: int;
    application_id: Snowflake.t option [@default None];
    widget_enabled: bool option [@default None];
    widget_channel: Channel_t.channel_wrapper option [@default None];
    system_channel: Channel_t.channel_wrapper option [@default None];
    large: bool;
    unavailable: bool;
    member_count: int option [@default None];
    members: Member_t.member list;
    channels: Channel_t.channel_wrapper list;
} [@@deriving sexp, yojson { strict = false }]

type t = {
    id: Snowflake.t;
    name: string;
    icon: string option [@default None];
    splash: string option [@default None];
    owner_id: Snowflake.t;
    region: string;
    afk_channel_id: Snowflake.t option [@default None];
    afk_timeout: int;
    embed_enabled: bool option [@default None];
    embed_channel_id: Snowflake.t option [@default None];
    verification_level: int;
    default_message_notifications: int;
    explicit_content_filter: int;
    roles: Role_t.t list;
    emojis: Emoji.t list;
    features: string list;
    mfa_level: int;
    application_id: Snowflake.t option [@default None];
    widget_enabled: bool option [@default None];
    widget_channel: Channel_t.t option [@default None];
    system_channel: Channel_t.t option [@default None];
    large: bool;
    unavailable: bool;
    member_count: int option [@default None];
    members: Member_t.t list;
    channels: Channel_t.t list;
} [@@deriving sexp, yojson { strict = false }]

let wrap ({id;name;icon;splash;owner_id;region;afk_channel_id;afk_timeout;embed_enabled;embed_channel_id;verification_level;default_message_notifications;explicit_content_filter;roles;emojis;features;mfa_level;application_id;widget_enabled;widget_channel;system_channel;large;unavailable;member_count;members;channels}:pre) =
    let roles = List.map ~f:(Role_t.wrap ~guild_id:id) roles in
    let members = List.map ~f:(Member_t.wrap ~guild_id:id) members in
    let channels = List.map ~f:Channel_t.wrap channels in
    let widget_channel = Option.map ~f:Channel_t.wrap widget_channel in
    let system_channel = Option.map ~f:Channel_t.wrap system_channel in
    {id;name;icon;splash;owner_id;region;afk_channel_id;afk_timeout;embed_enabled;embed_channel_id;verification_level;default_message_notifications;explicit_content_filter;roles;emojis;features;mfa_level;application_id;widget_enabled;widget_channel;system_channel;large;unavailable;member_count;members;channels}

let get_id guild = guild.id