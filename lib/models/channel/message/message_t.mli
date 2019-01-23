(** Represents data sent on {{!Dispatch.member_update}member update} events. *)
type message_update = {
    id: Snowflake.t;
    author: User_t.t option;
    channel_id: Snowflake.t;
    member: Member_t.partial_member option;
    guild_id: Snowflake.t option;
    content: string option;
    timestamp: string option;
    editedimestamp: string option;
    tts: bool option;
    mention_everyone: bool option;
    mentions: Snowflake.t list;
    role_mentions: Snowflake.t list;
    attachments: Attachment.t list;
    embeds: Embed.t list;
    reactions: Snowflake.t list;
    nonce: Snowflake.t option;
    pinned: bool option;
    webhook_id: Snowflake.t option;
    kind: int option;
} [@@deriving sexp, yojson]

(** Represents a message object. *)
type t = {
    id: Snowflake.t;
    author: User_t.t;
    channel_id: Snowflake.t;
    member: Member_t.partial_member option;
    guild_id: Snowflake.t option;
    content: string;
    timestamp: string;
    editedimestamp: string option;
    tts: bool;
    mention_everyone: bool;
    (* mentions: Snowflake.t list; *)
    (* role_mentions: Snowflake.t list; *)
    attachments: Attachment.t list;
    embeds: Embed.t list;
    reactions: Snowflake.t list;
    nonce: Snowflake.t option;
    pinned: bool;
    webhook_id: Snowflake.t option;
    kind: int;
} [@@deriving sexp, yojson]