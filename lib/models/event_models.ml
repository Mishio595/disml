open Core

module ChannelCreate = struct
    type t = {
        channel: Channel_t.t;
    } [@@deriving sexp]

    let deserialize ev =
        let channel = Channel_t.(channel_wrapper_of_yojson_exn ev |> wrap) in
        { channel; }
end

module ChannelDelete = struct
    type t = {
        channel: Channel_t.t;
    } [@@deriving sexp]

    let deserialize ev =
        let channel = Channel_t.(channel_wrapper_of_yojson_exn ev |> wrap) in
        { channel; }
end

module ChannelUpdate = struct
    type t = {
        channel: Channel_t.t;
    } [@@deriving sexp]

    let deserialize ev =
        let channel = Channel_t.(channel_wrapper_of_yojson_exn ev |> wrap) in
        { channel; }
end

module ChannelPinsUpdate = struct
    type t = {
        channel_id: Channel_id.t;
        last_pin_timestamp: string option [@default None];
    } [@@deriving sexp, yojson { strict = false }]

    let deserialize = of_yojson_exn
end

module ChannelRecipientAdd = struct
    type t = {
        channel_id: Channel_id.t;
        user: User_t.t;
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module ChannelRecipientRemove = struct
    type t = {
        channel_id: Channel_id.t;
        user: User_t.t;
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module GuildBanAdd = struct
    type t = {
        guild_id: Guild_id.t;
        user: User_t.t;
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module GuildBanRemove = struct
    type t = {
        guild_id: Guild_id.t;
        user: User_t.t;
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module GuildCreate = struct
    type t = {
        guild: Guild_t.t;
    } [@@deriving sexp]

    let deserialize ev =
        let guild = Guild_t.(pre_of_yojson_exn ev |> wrap) in
        { guild; }
end

module GuildDelete = struct
    type t = {
        id: Guild_id.t;
    } [@@deriving sexp, yojson { strict = false }]

    let deserialize = of_yojson_exn
end

module GuildUpdate = struct
    type t = {
        id: Guild_id.t;
    } [@@deriving sexp, yojson { strict = false }]

    let deserialize = of_yojson_exn
end

module GuildEmojisUpdate = struct
    type t = {
        emojis: Emoji.t list;
        guild_id: Guild_id.t
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module GuildMemberAdd = struct
    type t = {
        guild_id: Guild_id.t;
        member: Member_t.t;
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module GuildMemberRemove = struct
    type t = {
        guild_id: Guild_id.t;
        user: User_t.t;
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module GuildMemberUpdate = struct
    type t = {
        guild_id: Guild_id.t;
        nick: string option;
        roles: Role_id.t list;
        user: User_t.t;
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module GuildMembersChunk = struct
    type t = {
        guild_id: Guild_id.t;
        members: (Snowflake.t * Member_t.t) list;
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module GuildRoleCreate = struct
    type t = {
        guild_id: Guild_id.t;
        role: Role_t.t;
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module GuildRoleDelete = struct
    type t = {
        guild_id: Guild_id.t;
        role_id: Role_id.t;
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module GuildRoleUpdate = struct
    type t = {
        guild_id: Guild_id.t;
        role: Role_t.role;
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module GuildUnavailable = struct
    type t = {
        guild_id: Guild_id.t;
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module MessageCreate = struct
    type t = {
        message: Message_t.t;
    } [@@deriving sexp]

    let deserialize ev =
        let message = Message_t.of_yojson_exn ev in
        { message; }
end

module MessageDelete = struct
    type t = {
        id: Message_id.t;
        channel_id: Channel_id.t;
        guild_id: Guild_id.t option [@default None];
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module MessageUpdate = struct
    type t = {
        id: Message_id.t;
        author: User_t.t option [@default None];
        channel_id: Channel_id.t;
        member: Member_t.partial_member option [@default None];
        guild_id: Guild_id.t option [@default None];
        content: string option [@default None];
        timestamp: string option [@default None];
        editedimestamp: string option [@default None];
        tts: bool option [@default None];
        mention_everyone: bool option [@default None];
        mentions: User_id.t list [@default []];
        role_mentions: Role_id.t list [@default []];
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
        channel_id: Channel_id.t;
        ids: Message_id.t list;
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module PresenceUpdate = struct
    include Presence

    let deserialize = of_yojson_exn
end

(* module PresencesReplace = struct
    type t = 

    let deserialize = of_yojson_exn
end *)

module ReactionAdd = struct
    type t = {
        user_id: User_id.t;
        channel_id: Channel_id.t;
        message_id: Message_id.t;
        guild_id: Guild_id.t option [@default None];
        emoji: Emoji.partial_emoji;
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module ReactionRemove = struct
    type t = {
        user_id: User_id.t;
        channel_id: Channel_id.t;
        message_id: Message_id.t;
        guild_id: Guild_id.t option [@default None];
        emoji: Emoji.partial_emoji;
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module ReactionRemoveAll = struct
    type t = {
        channel_id: Channel_id.t;
        message_id: Message_id.t;
        guild_id: Guild_id.t option [@default None];
    } [@@deriving sexp, yojson]

    let deserialize = of_yojson_exn
end

module Ready = struct
    type t = {
        foo: bool option [@default None];
    } [@@deriving sexp, yojson { strict = false }]

    let deserialize = of_yojson_exn
end

module Resumed = struct
    type t = {
        trace: string option list;
    } [@@deriving sexp, yojson { strict = false }]

    let deserialize = of_yojson_exn
end

module TypingStart = struct
    type t = {
        channel_id: Channel_id.t;
        guild_id: Guild_id.t option [@default None];
        timestamp: int;
        user_id: User_id.t;
    } [@@deriving sexp, yojson { strict = false }]

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
        channel_id: Channel_id.t;
        guild_id: Guild_id.t;
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