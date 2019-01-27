(** Represents a message object. *)
type t = {
    id: Message_id.t;
    author: User_t.t;
    channel_id: Channel_id_t.t;
    member: Member_t.partial_member option;
    guild_id: Guild_id_t.t option;
    content: string;
    timestamp: string;
    editedimestamp: string option;
    tts: bool;
    mention_everyone: bool;
    mentions: User_id_t.t list;
    role_mentions: Role_id.t list;
    attachments: Attachment.t list;
    embeds: Embed.t list;
    reactions: Snowflake.t list;
    nonce: Snowflake.t option;
    pinned: bool;
    webhook_id: Snowflake.t option;
    kind: int;
} [@@deriving sexp, yojson]