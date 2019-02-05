open Core

module ChannelCreate = struct
    type t = {
        channel: Channel_t.t;
    } [@@deriving sexp]

    let deserialize ev =
        let channel = Channel_t.(channel_wrapper_of_yojson_exn ev |> wrap) in
        { channel; }

    let update_cache (cache:Cache.t) t =
        let open Channel_t in
        let module C = Cache.ChannelMap in
        match t.channel with
        | GuildText c ->
            let update = C.update cache.text_channels c.id ~f:(function
            | Some _ | None -> c) in
            Cache.cache := { cache with text_channels = update }
        | GuildVoice c ->
            let update = C.update cache.voice_channels c.id ~f:(function
            | Some _ | None -> c) in
            Cache.cache := { cache with voice_channels = update }
        | Category c ->
            let update = C.update cache.categories c.id ~f:(function
            | Some _ | None -> c) in
            Cache.cache := { cache with categories = update }
        | Group c ->
            let update = C.update cache.groups c.id ~f:(function
            | Some _ | None -> c) in
            Cache.cache := { cache with groups = update }
        | Private c ->
            let update = C.update cache.private_channels c.id ~f:(function
            | Some _ | None -> c) in
            Cache.cache := { cache with private_channels = update }
end

module ChannelDelete = struct
    type t = {
        channel: Channel_t.t;
    } [@@deriving sexp]

    let deserialize ev =
        let channel = Channel_t.(channel_wrapper_of_yojson_exn ev |> wrap) in
        { channel; }

    let update_cache (cache:Cache.t) t =
        let open Channel_t in
        let module C = Cache.ChannelMap in
        match t.channel with
        | GuildText c ->
            let update = C.remove cache.text_channels c.id in
            Cache.cache := { cache with text_channels = update }
        | GuildVoice c ->
            let update = C.remove cache.voice_channels c.id in
            Cache.cache := { cache with voice_channels = update }
        | Category c ->
            let update = C.remove cache.categories c.id in
            Cache.cache := { cache with categories = update }
        | Group c ->
            let update = C.remove cache.groups c.id in
            Cache.cache := { cache with groups = update }
        | Private c ->
            let update = C.remove cache.private_channels c.id in
            Cache.cache := { cache with private_channels = update }
end

module ChannelUpdate = struct
    type t = {
        channel: Channel_t.t;
    } [@@deriving sexp]

    let deserialize ev =
        let channel = Channel_t.(channel_wrapper_of_yojson_exn ev |> wrap) in
        { channel; }

    let update_cache (cache:Cache.t) t =
        let open Channel_t in
        let module C = Cache.ChannelMap in
        match t.channel with
        | GuildText c ->
            let update = C.update cache.text_channels c.id ~f:(function
            | Some _ -> c
            | None -> c) in
            Cache.cache := { cache with text_channels = update }
        | GuildVoice c ->
            let update = C.update cache.voice_channels c.id ~f:(function
            | Some _ -> c
            | None -> c) in
            Cache.cache := { cache with voice_channels = update }
        | Category c ->
            let update = C.update cache.categories c.id ~f:(function
            | Some _ -> c
            | None -> c) in
            Cache.cache := { cache with categories = update }
        | Group c ->
            let update = C.update cache.groups c.id ~f:(function
            | Some _ -> c
            | None -> c) in
            Cache.cache := { cache with groups = update }
        | Private c ->
            let update = C.update cache.private_channels c.id ~f:(function
            | Some _ -> c
            | None -> c) in
            Cache.cache := { cache with private_channels = update }
end

module ChannelPinsUpdate = struct
    type t = {
        channel_id: Channel_id.t;
        last_pin_timestamp: string option [@default None];
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.t) t =
        let module C = Cache.ChannelMap in
        if C.mem cache.private_channels t.channel_id then
            let update = match C.find cache.private_channels t.channel_id with
            | Some c -> C.set cache.private_channels ~key:t.channel_id ~data:{ c with last_pin_timestamp = t.last_pin_timestamp }
            | None -> cache.private_channels in
            Cache.cache := { cache with private_channels = update }
        else if C.mem cache.text_channels t.channel_id then
            let update = match C.find cache.text_channels t.channel_id with
            | Some c -> C.set cache.text_channels ~key:t.channel_id ~data:{ c with last_pin_timestamp = t.last_pin_timestamp }
            | None -> cache.text_channels in
            Cache.cache := { cache with text_channels = update }
        else if C.mem cache.groups t.channel_id then
            let update = match C.find cache.groups t.channel_id with
            | Some c -> C.set cache.groups ~key:t.channel_id ~data:{ c with last_pin_timestamp = t.last_pin_timestamp }
            | None -> cache.groups in
            Cache.cache := { cache with groups = update }
end

(* Don't see where these would get used *)

(* module ChannelRecipientAdd = struct
    type t = {
        channel_id: Channel_id.t;
        user: User_t.t;
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.t) t = ()
end *)

(* module ChannelRecipientRemove = struct
    type t = {
        channel_id: Channel_id.t;
        user: User_t.t;
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.t) t = ()
end *)

(* TODO decide on ban caching, if any *)
module GuildBanAdd = struct
    type t = {
        guild_id: Guild_id.t;
        user: User_t.t;
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (_cache:Cache.t) _t = ()
end

module GuildBanRemove = struct
    type t = {
        guild_id: Guild_id.t;
        user: User_t.t;
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (_cache:Cache.t) _t = ()
end

module GuildCreate = struct
    type t = {
        guild: Guild_t.t;
    } [@@deriving sexp]

    let deserialize ev =
        let guild = Guild_t.(pre_of_yojson_exn ev |> wrap) in
        { guild; }

    let update_cache (cache:Cache.t) t =
        let update = Cache.GuildMap.update cache.guilds t.guild.id ~f:(function
        | Some _ | None -> t.guild) in
        Cache.cache := { cache with guilds = update }
end

module GuildDelete = struct
    type t = {
        id: Guild_id.t;
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.t) t =
        let update = Cache.GuildMap.remove cache.guilds t.id in
        Cache.cache := { cache with guilds = update }
end

module GuildUpdate = struct
    type t = {
        guild: Guild_t.t;
    } [@@deriving sexp]

    let deserialize ev =
        let guild = Guild_t.(pre_of_yojson_exn ev |> wrap) in
        { guild; }

    let update_cache (cache:Cache.t) t =
        let open Guild_t in
        let {id;name;icon;splash;owner_id;region;
            afk_channel_id;verification_level;
            default_message_notifications;
            explicit_content_filter;
            features;mfa_level;application_id;
            widget_enabled;widget_channel_id;
            system_channel_id;_} = t.guild in
        let update = Cache.GuildMap.update cache.guilds id ~f:(function
        | Some g' -> { g' with
            id;name;icon;splash;owner_id;region;
            afk_channel_id;verification_level;
            default_message_notifications;
            explicit_content_filter;
            features;mfa_level;application_id;
            widget_enabled;widget_channel_id;
            system_channel_id }
        | None -> t.guild) in
        Cache.cache := { cache with guilds = update }
end

module GuildEmojisUpdate = struct
    type t = {
        emojis: Emoji.t list;
        guild_id: Guild_id.t
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.t) t =
        if Cache.GuildMap.mem cache.guilds t.guild_id then
            let update = match Cache.GuildMap.find cache.guilds t.guild_id with
            | Some g -> Cache.GuildMap.set cache.guilds ~key:t.guild_id ~data:{ g with emojis = t.emojis }
            | None -> cache.guilds in
            Cache.cache := { cache with guilds = update }
end

(* TODO guild integrations *)

module GuildMemberAdd = struct
    include Member_t

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.t) t =
        if Cache.GuildMap.mem cache.guilds t.guild_id then
            let update = match Cache.GuildMap.find cache.guilds t.guild_id with
            | Some g -> 
                let members = t :: g.members in
                let data = { g with members } in
                Cache.GuildMap.set cache.guilds ~key:t.guild_id ~data
            | None -> cache.guilds in
            Cache.cache := { cache with guilds = update }
end

module GuildMemberRemove = struct
    type t = {
        guild_id: Guild_id.t;
        user: User_t.t;
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.t) t =
        if Cache.GuildMap.mem cache.guilds t.guild_id then
            let update = match Cache.GuildMap.find cache.guilds t.guild_id with
            | Some g -> 
                let members = List.filter g.members ~f:(fun m -> m.user.id <> t.user.id) in
                let data = { g with members } in
                Cache.GuildMap.set cache.guilds ~key:t.guild_id ~data
            | None -> cache.guilds in
            Cache.cache := { cache with guilds = update }
end

module GuildMemberUpdate = struct
    type t = {
        guild_id: Guild_id.t;
        nick: string option;
        roles: Role_id.t list;
        user: User_t.t;
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.t) t =
        if Cache.GuildMap.mem cache.guilds t.guild_id then
            let update = match Cache.GuildMap.find cache.guilds t.guild_id with
            | Some g -> 
                let members = List.map g.members ~f:(fun m ->
                    if m.user.id = t.user.id then
                        { m with nick = t.nick; roles = t.roles }
                    else m) in
                let data = { g with members } in
                Cache.GuildMap.set cache.guilds ~key:t.guild_id ~data
            | None -> cache.guilds in
            Cache.cache := { cache with guilds = update }
end

(* TODO figure out if this deserializes properly, then add cache update *)
module GuildMembersChunk = struct
    type t = {
        guild_id: Guild_id.t;
        members: (Snowflake.t * Member_t.t) list;
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (_cache:Cache.t) _t = ()
end

module GuildRoleCreate = struct
    type t = {
        guild_id: Guild_id.t;
        role: Role_t.role;
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.t) t =
        if Cache.GuildMap.mem cache.guilds t.guild_id then
            let update = match Cache.GuildMap.find cache.guilds t.guild_id with
            | Some g ->
                let `Guild_id guild_id = t.guild_id in
                let roles = Role_t.wrap ~guild_id t.role :: g.roles in
                let data = { g with roles } in
                Cache.GuildMap.set cache.guilds ~key:t.guild_id ~data
            | None -> cache.guilds in
            Cache.cache := { cache with guilds = update }
end

module GuildRoleDelete = struct
    type t = {
        guild_id: Guild_id.t;
        role_id: Role_id.t;
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.t) t =
        if Cache.GuildMap.mem cache.guilds t.guild_id then
            let update = match Cache.GuildMap.find cache.guilds t.guild_id with
            | Some g ->
                let roles = List.filter g.roles ~f:(fun r -> r.id <> t.role_id) in
                let data = { g with roles } in
                Cache.GuildMap.set cache.guilds ~key:t.guild_id ~data
            | None -> cache.guilds in
            Cache.cache := { cache with guilds = update }
end

module GuildRoleUpdate = struct
    type t = {
        guild_id: Guild_id.t;
        role: Role_t.role;
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.t) t =
        if Cache.GuildMap.mem cache.guilds t.guild_id then
            let update = match Cache.GuildMap.find cache.guilds t.guild_id with
            | Some g ->
                let `Guild_id guild_id = t.guild_id in
                let roles = List.map g.roles ~f:(fun r ->
                    if r.id = t.role.id then Role_t.wrap ~guild_id t.role else r) in
                let data = { g with roles } in
                Cache.GuildMap.set cache.guilds ~key:t.guild_id ~data
            | None -> cache.guilds in
            Cache.cache := { cache with guilds = update }
end

(* TODO figure out if this is necessary *)
module GuildUnavailable = struct
    type t = {
        guild_id: Guild_id.t;
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (_cache:Cache.t) _t = ()
end

module MessageCreate = struct
    type t = {
        message: Message_t.t;
    } [@@deriving sexp]

    let deserialize ev =
        let message = Message_t.of_yojson_exn ev in
        { message; }

    let update_cache (_cache:Cache.t) _t = ()
end

module MessageDelete = struct
    type t = {
        id: Message_id.t;
        channel_id: Channel_id.t;
        guild_id: Guild_id.t option [@default None];
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (_cache:Cache.t) _t = ()
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
        mentions: User_t.t list [@default []];
        role_mentions: Role_id.t list [@default []];
        attachments: Attachment.t list [@default []];
        embeds: Embed.t list [@default []];
        reactions: Reaction_t.t list [@default []];
        nonce: Snowflake.t option [@default None];
        pinned: bool option [@default None];
        webhook_id: Snowflake.t option [@default None];
        kind: int option [@default None][@key "type"];
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (_cache:Cache.t) _t = ()
end

module MessageDeleteBulk = struct
    type t = {
        guild_id: Guild_id.t option [@default None];
        channel_id: Channel_id.t;
        ids: Message_id.t list;
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (_cache:Cache.t) _t = ()
end

module PresenceUpdate = struct
    include Presence

    let deserialize = of_yojson_exn

    let update_cache (_cache:Cache.t) _t = ()
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
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (_cache:Cache.t) _t = ()
end

module ReactionRemove = struct
    type t = {
        user_id: User_id.t;
        channel_id: Channel_id.t;
        message_id: Message_id.t;
        guild_id: Guild_id.t option [@default None];
        emoji: Emoji.partial_emoji;
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (_cache:Cache.t) _t = ()
end

module ReactionRemoveAll = struct
    type t = {
        channel_id: Channel_id.t;
        message_id: Message_id.t;
        guild_id: Guild_id.t option [@default None];
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (_cache:Cache.t) _t = ()
end

module Ready = struct
    type t = {
        version: int [@key "v"];
        user: User_t.t;
        private_channels: Channel_id.t list;
        guilds: Guild_t.unavailable list;
        session_id: string;
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.t) t =
        let user = Some t.user in
        Cache.cache := { cache with user }
end

module Resumed = struct
    type t = {
        trace: string option list [@key "_trace"];
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (_cache:Cache.t) _t = ()
end

module TypingStart = struct
    type t = {
        channel_id: Channel_id.t;
        guild_id: Guild_id.t option [@default None];
        timestamp: int;
        user_id: User_id.t;
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (_cache:Cache.t) _t = ()
end

module UserUpdate = struct
    type t = {
        user: User_t.t;
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize ev =
        let user = User_t.of_yojson_exn ev in
        { user; }

    let update_cache (cache:Cache.t) t =
        let user = Some t.user in
        Cache.cache := { cache with user }
end

module WebhookUpdate = struct
    type t = {
        channel_id: Channel_id.t;
        guild_id: Guild_id.t;
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (_cache:Cache.t) _t = ()
end

module Unknown = struct
    type t = {
        kind: string;
        value: Yojson.Safe.t;
    }

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