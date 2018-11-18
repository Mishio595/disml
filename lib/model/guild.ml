type t = {
    afk_channel_id: int option;
    afk_timeout: int;
    application_id: int option;
    channels: Channel.t list;
    default_message_notifications: int;
    emojis: Emoji.t list;
    explicit_content_filter: int;
    features: string list;
    icon: string option;
    id: int;
    joined_at: string;
    large: bool;
    member_count: int;
    members: Member.t list;
    mfa_level: int;
    name: string;
    owner_id: int;
    presences: Presence.t list;
    region: string;
    roles: Role.t list;
    splash: string option;
    system_channel_id: int option;
    verification_level: int;
    voice_states: VoiceState.t list;
}
