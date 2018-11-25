type t = {
    id: Snowflake.t;
    author: User.t;
    channel: Channel.t;
    member: Member.t option;
    guild: Guild.t option;
    content: string;
    timestamp: string;
    edited_timestamp: string option;
    tts: bool;
    mention_everyone: bool;
    mentions: User.t list;
    role_mentions: Role.t list;
    attachments: Attachment.t list;
    embeds: Embed.t list;
    reactions: Reaction.t list;
    nonce: Snowflake.t option;
    pinned: bool;
    webhook_id: Snowflake.t;
    kind: int;
}