type t = {
    id: Snowflake.t;
    name: string;
    icon: string;
    splash: string;
    owner: User.t;
    region: string;
    afk_channel: Channel.t option;
    afk_timeout: int;
    embed_enabled: bool;
    embed_channel: Channel.t;
    verification_level: int;
    default_message_notifications: int;
    explicit_content_filter: int;
    roles: Role.t list;
    emojis: Emoji.t list;
    features: string list;
    mfa_level: int;
    application_id: Snowflake.t option;
    widget_enabled: bool option;
    widget_channel: Channel.t option;
    system_channel: Channel.t option;
    large: bool;
    unavailable: bool;
    member_count: int;
    members: Member.t list;
    channels: Channel.t list;
} [@@deriving yojson]