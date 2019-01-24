open Core

module ChannelCreate = struct
    type t = {
        channel: Channel_t.t;
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module ChannelDelete = struct
    type t = {
        channel: Channel_t.t;
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module ChannelUpdate = struct
    type t = {
        channel: Channel_t.t;
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module ChannelPinsUpdate = struct
    type t = {
        channel_id: Channel_id_t.t;
        last_pin_timestamp: string option;
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module ChannelRecipientAdd = struct
    type t = {
        channel_id: Channel_id_t.t;
        user: User_t.t;
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module ChannelRecipientRemove = struct
    type t = {
        channel_id: Channel_id_t.t;
        user: User_t.t;
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module GuildBanAdd = struct
    type t = {
        guild_id: Guild_id_t.t;
        user: User_t.t;
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module GuildBanRemove = struct
    type t = {
        guild_id: Guild_id_t.t;
        user: User_t.t;
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module GuildCreate = struct
    type t = {
        guild: Guild_t.t;
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

(* TODO *)
module GuildDelete = struct
    type t = {
        foo: bool option [@default None];
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

(* TODO *)
module GuildUpdate = struct
    type t = {
        foo: bool option [@default None];
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module GuildEmojisUpdate = struct
    type t = {
        emojis: Emoji.t list;
        guild_id: Guild_id_t.t
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module GuildMemberAdd = struct
    type t = {
        guild_id: Guild_id_t.t;
        member: Member_t.t;
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module GuildMemberRemove = struct
    type t = {
        guild_id: Guild_id_t.t;
        user: User_t.t;
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module GuildMemberUpdate = struct
    type t = {
        guild_id: Guild_id_t.t;
        nick: string option;
        roles: Role_id.t list;
        user: User_t.t;
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module GuildMembersChunk = struct
    type t = {
        guild_id: Guild_id_t.t;
        members: (Snowflake.t * Member_t.t) list;
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module GuildRoleCreate = struct
    type t = {
        guild_id: Guild_id_t.t;
        role: Role_t.t;
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module GuildRoleDelete = struct
    type t = {
        guild_id: Guild_id_t.t;
        role_id: Role_id.t;
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module GuildRoleUpdate = struct
    type t = {
        guild_id: Guild_id_t.t;
        role: Role_t.t;
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module GuildUnavailable = struct
    type t = {
        guild_id: Guild_id_t.t;
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module MessageCreate = struct
    type t = {
        message: Message_t.t;
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module MessageDelete = struct
    type t = {
        channel_id: Channel_id_t.t;
        message_id: Message_id.t;
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module MessageUpdate = struct
    type t = {
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
    } [@@deriving sexp, yojson { strict = false}]

    let deserialize = of_yojson_exn
end

module MessageDeleteBulk = struct
    type t = {
        channel_id: Channel_id_t.t;
        ids: Message_id.t list;
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module PresenceUpdate = struct
    type t = {
        guild_id: Guild_id_t.t option;
        presence: Presence.t;
        roles: Role_id.t list option;
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

(* module PresencesReplace = struct
    type t = 

    let deserialize = of_yojson_exn
end *)

module ReactionAdd = struct
    type t = {
        reaction: Reaction_t.t;
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module ReactionRemove = struct
    type t = {
        reaction: Reaction_t.t;
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module ReactionRemoveAll = struct
    type t = {
        channel_id: Channel_id_t.t;
        message_id: Message_id.t;
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module Ready = struct
    type t = {
        foo: bool option [@default None];
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module Resumed = struct
    type t = {
        trace: string option list;
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module TypingStart = struct
    type t = {
        channel_id: Channel_id_t.t;
        timestamp: int;
        user_id: User_id_t.t;
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module UserUpdate = struct
    type t = {
        user: User_t.t;
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module WebhookUpdate = struct
    type t = {
        channel_id: Channel_id_t.t;
        guild_id: Guild_id_t.t;
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module Unknown = struct
    type t = {
        kind: string;
        value: Yojson.Safe.json;
    } [@@deriving yojson]

    let deserialize kind value = { kind; value; } 
end

(* module VoiceHeartbeat = struct

end

module VoiceHello = struct

end

module VoiceServerUpdate = struct

end

module VoiceSessionDescription = struct

end

module VoiceSpeaking = struct

end

module VoiceStateUpdate = struct

end *)