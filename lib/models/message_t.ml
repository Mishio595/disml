type message_update = {
    id: Snowflake.t;
    author: User_t.t option [@default None];
    channel_id: Snowflake.t;
    member: Member_t.partial_member option [@default None];
    guild_id: Snowflake.t option [@default None];
    content: string option [@default None];
    timestamp: string option [@default None];
    editedimestamp: string option [@default None];
    tts: bool option [@default None];
    mention_everyone: bool option [@default None];
    mentions: Snowflake.t list [@default []];
    role_mentions: Snowflake.t list [@default []];
    attachments: Attachment.t list [@default []];
    embeds: Embed.t list [@default []];
    reactions: Snowflake.t list [@default []];
    nonce: Snowflake.t option [@default None];
    pinned: bool option [@default None];
    webhook_id: Snowflake.t option [@default None];
    kind: int option [@default None][@key "type"];
} [@@deriving yojson { strict = false}]

type t = {
    id: Snowflake.t;
    author: User_t.t;
    channel_id: Snowflake.t;
    member: Member_t.partial_member option [@default None];
    guild_id: Snowflake.t option [@default None];
    content: string;
    timestamp: string;
    editedimestamp: string option [@default None];
    tts: bool;
    mention_everyone: bool;
    (* mentions: Snowflake.t list [@default []]; *)
    (* role_mentions: Snowflake.t list [@default []]; *)
    attachments: Attachment.t list [@default []];
    embeds: Embed.t list [@default []];
    reactions: Snowflake.t list [@default []];
    nonce: Snowflake.t option [@default None];
    pinned: bool;
    webhook_id: Snowflake.t option [@default None];
    kind: int [@key "type"];
} [@@deriving yojson { strict = false}]