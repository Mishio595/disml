open Core

module ChannelCreate = struct
    type t = Channel_t.t

    let deserialize ev =
        Channel_t.(channel_wrapper_of_yojson_exn ev |> wrap)

    let update_cache (cache:Cache.t) t =
        let open Channel_t in
        let module C = Cache.ChannelMap in
        match t with
        | GuildText c ->
            let text_channels = C.update cache.text_channels c.id ~f:(function
            | Some _ | None -> c) in
            { cache with text_channels }
        | GuildVoice c ->
            let voice_channels = C.update cache.voice_channels c.id ~f:(function
            | Some _ | None -> c) in
            { cache with voice_channels }
        | Category c ->
            let categories = C.update cache.categories c.id ~f:(function
            | Some _ | None -> c) in
            { cache with categories }
        | Group c ->
            let groups = C.update cache.groups c.id ~f:(function
            | Some _ | None -> c) in
            { cache with groups }
        | Private c ->
            let private_channels = C.update cache.private_channels c.id ~f:(function
            | Some _ | None -> c) in
            { cache with private_channels }
end

module ChannelDelete = struct
    type t = Channel_t.t

    let deserialize ev =
        Channel_t.(channel_wrapper_of_yojson_exn ev |> wrap)

    let update_cache (cache:Cache.t) t =
        let open Channel_t in
        let module C = Cache.ChannelMap in
        match t with
        | GuildText c ->
            let text_channels = C.remove cache.text_channels c.id in
            { cache with text_channels }
        | GuildVoice c ->
            let voice_channels = C.remove cache.voice_channels c.id in
            { cache with voice_channels }
        | Category c ->
            let categories = C.remove cache.categories c.id in
            { cache with categories }
        | Group c ->
            let groups = C.remove cache.groups c.id in
            { cache with groups }
        | Private c ->
            let private_channels = C.remove cache.private_channels c.id in
            { cache with private_channels }
end

module ChannelUpdate = struct
    type t = Channel_t.t

    let deserialize ev =
        Channel_t.(channel_wrapper_of_yojson_exn ev |> wrap)

    let update_cache (cache:Cache.t) t =
        let open Channel_t in
        let module C = Cache.ChannelMap in
        match t with
        | GuildText c ->
            let text_channels = C.update cache.text_channels c.id ~f:(function
            | Some _ -> c
            | None -> c) in
            { cache with text_channels }
        | GuildVoice c ->
            let voice_channels = C.update cache.voice_channels c.id ~f:(function
            | Some _ -> c
            | None -> c) in
            { cache with voice_channels }
        | Category c ->
            let categories = C.update cache.categories c.id ~f:(function
            | Some _ -> c
            | None -> c) in
            { cache with categories }
        | Group c ->
            let groups = C.update cache.groups c.id ~f:(function
            | Some _ -> c
            | None -> c) in
            { cache with groups }
        | Private c ->
            let private_channels = C.update cache.private_channels c.id ~f:(function
            | Some _ -> c
            | None -> c) in
            { cache with private_channels }
end

module ChannelPinsUpdate = struct
    type t =
    { channel_id: Channel_id.t
    ; last_pin_timestamp: string option [@default None]
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.t) t =
        let module C = Cache.ChannelMap in
        if C.mem cache.private_channels t.channel_id then
            let private_channels = match C.find cache.private_channels t.channel_id with
            | Some c -> C.set cache.private_channels ~key:t.channel_id ~data:{ c with last_pin_timestamp = t.last_pin_timestamp }
            | None -> cache.private_channels in
            { cache with private_channels }
        else if C.mem cache.text_channels t.channel_id then
            let text_channels = match C.find cache.text_channels t.channel_id with
            | Some c -> C.set cache.text_channels ~key:t.channel_id ~data:{ c with last_pin_timestamp = t.last_pin_timestamp }
            | None -> cache.text_channels in
            { cache with text_channels }
        else if C.mem cache.groups t.channel_id then
            let groups = match C.find cache.groups t.channel_id with
            | Some c -> C.set cache.groups ~key:t.channel_id ~data:{ c with last_pin_timestamp = t.last_pin_timestamp }
            | None -> cache.groups in
            { cache with groups }
        else cache
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
    type t =
    { guild_id: Guild_id.t
    ; user: User_t.t
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.t) _t = cache
end

module GuildBanRemove = struct
    type t =
    { guild_id: Guild_id.t
    ; user: User_t.t
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.t) _t = cache
end

module GuildCreate = struct
    type t = Guild_t.t

    let deserialize ev =
        Guild_t.(pre_of_yojson_exn ev |> wrap)

    let update_cache (cache:Cache.t) (t:t) =
        let open Channel_t in
        let module C = Cache.ChannelMap in
        let guilds = Cache.GuildMap.update cache.guilds t.id ~f:(function
        | Some _ | None -> t) in
        let text, voice, cat = ref [], ref [], ref [] in
        List.iter t.channels ~f:(function
        | GuildText c -> text := (c.id, c) :: !text
        | GuildVoice c -> voice := (c.id, c) :: !voice
        | Category c -> cat := (c.id, c) :: !cat
        | _ -> ());
        let text_channels = match C.of_alist !text with
        | `Ok m ->
            C.merge m cache.text_channels ~f:(fun ~key -> function
            | `Both (c, _) | `Left c | `Right c -> let _ = key in Some c)
        | _ -> cache.text_channels in
        let voice_channels = match C.of_alist !voice with
        | `Ok m ->
            C.merge m cache.voice_channels ~f:(fun ~key -> function
            | `Both (c, _) | `Left c | `Right c -> let _ = key in Some c)
        | _ -> cache.voice_channels in
        let categories = match C.of_alist !cat with
        | `Ok m ->
            C.merge m cache.categories ~f:(fun ~key -> function
            | `Both (c, _) | `Left c | `Right c -> let _ = key in Some c)
        | _ -> cache.categories in
        let users = List.map t.members ~f:(fun m -> m.user.id, m.user) in
        let users = match Cache.UserMap.of_alist users with
        | `Ok m ->
            Cache.UserMap.merge m cache.users ~f:(fun ~key -> function
            | `Both (u, _) | `Left u | `Right u -> let _ = key in Some u)
        | _ -> cache.users in
        { cache with guilds
        ; text_channels
        ; voice_channels
        ; categories
        ; users
        }
end

module GuildDelete = struct
    type t = Guild_t.unavailable =
    { id: Guild_id_t.t
    ; unavailable: bool
    }
    
    let deserialize = Guild_t.unavailable_of_yojson_exn

    let update_cache (cache:Cache.t) (t:t) =
        let open Channel_t in
        let module G = Cache.GuildMap in
        let module C = Cache.ChannelMap in
        match G.find cache.guilds t.id with
        | Some g ->
            let text_channels = ref cache.text_channels in
            let voice_channels = ref cache.voice_channels in
            let categories = ref cache.categories in
            List.iter g.channels ~f:(function
                | GuildText c -> text_channels := C.remove cache.text_channels c.id
                | GuildVoice c -> voice_channels := C.remove cache.voice_channels c.id
                | Category c -> categories := C.remove cache.categories c.id
                | _ -> ()
            );
            let guilds = G.remove cache.guilds g.id in
            let text_channels, voice_channels, categories = !text_channels, !voice_channels, !categories in
            { cache with guilds
            ; text_channels
            ; voice_channels
            ; categories
            }
        | None ->
            let guilds = G.remove cache.guilds t.id in
            { cache with guilds }
end

module GuildUpdate = struct
    type t = Guild_t.t

    let deserialize ev =
        Guild_t.(pre_of_yojson_exn ev |> wrap)

    let update_cache (cache:Cache.t) t =
        let open Guild_t in
        let {id; _} = t in
        let guilds = Cache.GuildMap.update cache.guilds id ~f:(function
        | Some _ | None -> t) in
        { cache with guilds }
end

module GuildEmojisUpdate = struct
    type t =
    { emojis: Emoji.t list
    ; guild_id: Guild_id.t
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.t) t =
        if Cache.GuildMap.mem cache.guilds t.guild_id then
            let guilds = match Cache.GuildMap.find cache.guilds t.guild_id with
            | Some g -> Cache.GuildMap.set cache.guilds ~key:t.guild_id ~data:{ g with emojis = t.emojis }
            | None -> cache.guilds in
            { cache with guilds }
        else cache
end

(* TODO guild integrations *)

module GuildMemberAdd = struct
    type t = Member_t.t

    let deserialize = Member_t.of_yojson_exn

    let update_cache (cache:Cache.t) (t:t) =
        if Cache.GuildMap.mem cache.guilds t.guild_id then
            let guilds = match Cache.GuildMap.find cache.guilds t.guild_id with
            | Some g -> 
                let members = t :: g.members in
                let data = { g with members } in
                Cache.GuildMap.set cache.guilds ~key:t.guild_id ~data
            | None -> cache.guilds in
            { cache with guilds }
        else cache
end

module GuildMemberRemove = struct
    type t =
    { guild_id: Guild_id.t
    ; user: User_t.t
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.t) t =
        if Cache.GuildMap.mem cache.guilds t.guild_id then
            let guilds = match Cache.GuildMap.find cache.guilds t.guild_id with
            | Some g -> 
                let members = List.filter g.members ~f:(fun m -> m.user.id <> t.user.id) in
                let data = { g with members } in
                Cache.GuildMap.set cache.guilds ~key:t.guild_id ~data
            | None -> cache.guilds in
            { cache with guilds }
        else cache
end

module GuildMemberUpdate = struct
    type t =
    { guild_id: Guild_id.t
    ; nick: string option
    ; roles: Role_id.t list
    ; user: User_t.t
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.t) t =
        if Cache.GuildMap.mem cache.guilds t.guild_id then
            let guilds = match Cache.GuildMap.find cache.guilds t.guild_id with
            | Some g -> 
                let members = List.map g.members ~f:(fun m ->
                    if m.user.id = t.user.id then
                        { m with nick = t.nick; roles = t.roles }
                    else m) in
                let data = { g with members } in
                Cache.GuildMap.set cache.guilds ~key:t.guild_id ~data
            | None -> cache.guilds in
            { cache with guilds }
        else cache
end

module GuildMembersChunk = struct
    type t =
    { guild_id: Guild_id.t
    ; members: Member_t.member list
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.t) t =
        match Cache.GuildMap.find cache.guilds t.guild_id with
        | None -> cache
        | Some g ->
            let `Guild_id guild_id = t.guild_id in
            let users = List.map t.members ~f:(fun m -> m.user.id, m.user) in
            let members = List.filter_map t.members ~f:(fun m ->
                if List.exists g.members ~f:(fun m' -> m'.user.id <> m.user.id) then
                    Some (Member_t.wrap ~guild_id m)
                else None) in
            let guilds = Cache.GuildMap.set cache.guilds ~key:t.guild_id ~data:{ g with members } in
            let users = match Cache.UserMap.of_alist users with
            | `Ok m ->
                Cache.UserMap.merge m cache.users ~f:(fun ~key -> function
                | `Both (u, _) | `Left u | `Right u -> let _ = key in Some u)
            | _ -> cache.users in
            { cache with guilds
            ; users
            }

end

module GuildRoleCreate = struct
    type t =
    { guild_id: Guild_id.t
    ; role: Role_t.role
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.t) t =
        if Cache.GuildMap.mem cache.guilds t.guild_id then
            let guilds = match Cache.GuildMap.find cache.guilds t.guild_id with
            | Some g ->
                let `Guild_id guild_id = t.guild_id in
                let roles = Role_t.wrap ~guild_id t.role :: g.roles in
                let data = { g with roles } in
                Cache.GuildMap.set cache.guilds ~key:t.guild_id ~data
            | None -> cache.guilds in
            { cache with guilds }
        else cache
end

module GuildRoleDelete = struct
    type t =
    { guild_id: Guild_id.t
    ; role_id: Role_id.t
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.t) t =
        if Cache.GuildMap.mem cache.guilds t.guild_id then
            let guilds = match Cache.GuildMap.find cache.guilds t.guild_id with
            | Some g ->
                let roles = List.filter g.roles ~f:(fun r -> r.id <> t.role_id) in
                let data = { g with roles } in
                Cache.GuildMap.set cache.guilds ~key:t.guild_id ~data
            | None -> cache.guilds in
            { cache with guilds }
        else cache
end

module GuildRoleUpdate = struct
    type t =
    { guild_id: Guild_id.t
    ; role: Role_t.role
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.t) t =
        if Cache.GuildMap.mem cache.guilds t.guild_id then
            let guilds = match Cache.GuildMap.find cache.guilds t.guild_id with
            | Some g ->
                let `Guild_id guild_id = t.guild_id in
                let roles = List.map g.roles ~f:(fun r ->
                    if r.id = t.role.id then Role_t.wrap ~guild_id t.role else r) in
                let data = { g with roles } in
                Cache.GuildMap.set cache.guilds ~key:t.guild_id ~data
            | None -> cache.guilds in
            { cache with guilds }
        else cache
end

module MessageCreate = struct
    type t = Message_t.t

    let deserialize =
        Message_t.of_yojson_exn

    let update_cache (cache:Cache.t) _t = cache
end

module MessageDelete = struct
    type t =
    { id: Message_id.t
    ; channel_id: Channel_id.t
    ; guild_id: Guild_id.t option [@default None]
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.t) _t = cache
end

module MessageUpdate = struct
    type t =
    { id: Message_id.t
    ; author: User_t.t option [@default None]
    ; channel_id: Channel_id.t
    ; member: Member_t.partial_member option [@default None]
    ; guild_id: Guild_id.t option [@default None]
    ; content: string option [@default None]
    ; timestamp: string option [@default None]
    ; editedimestamp: string option [@default None]
    ; tts: bool option [@default None]
    ; mention_everyone: bool option [@default None]
    ; mentions: User_t.t list [@default []]
    ; role_mentions: Role_id.t list [@default []]
    ; attachments: Attachment.t list [@default []]
    ; embeds: Embed.t list [@default []]
    ; reactions: Reaction_t.t list [@default []]
    ; nonce: Snowflake.t option [@default None]
    ; pinned: bool option [@default None]
    ; webhook_id: Snowflake.t option [@default None]
    ; kind: int option [@default None][@key "type"]
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.t) _t = cache
end

module MessageDeleteBulk = struct
    type t =
    { guild_id: Guild_id.t option [@default None]
    ; channel_id: Channel_id.t
    ; ids: Message_id.t list
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.t) _t = cache
end

module PresenceUpdate = struct
    type t = Presence.t

    let deserialize = Presence.of_yojson_exn

    let update_cache (cache:Cache.t) (t:t) =
        let id = t.user.id in
        let presences = Cache.UserMap.update cache.presences id ~f:(function Some _ | None -> t) in
        { cache with presences }
end

(* module PresencesReplace = struct
    type t = 

    let deserialize = of_yojson_exn
end *)

module ReactionAdd = struct
    type t =
    { user_id: User_id.t
    ; channel_id: Channel_id.t
    ; message_id: Message_id.t
    ; guild_id: Guild_id.t option [@default None]
    ; emoji: Emoji.partial_emoji
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.t) _t = cache
end

module ReactionRemove = struct
    type t =
    { user_id: User_id.t
    ; channel_id: Channel_id.t
    ; message_id: Message_id.t
    ; guild_id: Guild_id.t option [@default None]
    ; emoji: Emoji.partial_emoji
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.t) _t = cache
end

module ReactionRemoveAll = struct
    type t =
    { channel_id: Channel_id.t
    ; message_id: Message_id.t
    ; guild_id: Guild_id.t option [@default None]
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.t) _t = cache
end

module Ready = struct
    type t =
    { version: int [@key "v"]
    ; user: User_t.t
    ; private_channels: Channel_id.t list
    ; guilds: Guild_t.unavailable list
    ; session_id: string
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.t) t =
        let user = Some t.user in
        { cache with user }
end

module Resumed = struct
    type t = { trace: string option list [@key "_trace"] }
    [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.t) _t = cache
end

module TypingStart = struct
    type t =
    { channel_id: Channel_id.t
    ; guild_id: Guild_id.t option [@default None]
    ; timestamp: int
    ; user_id: User_id.t
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.t) _t = cache
end

module UserUpdate = struct
    type t = User_t.t

    let deserialize = User_t.of_yojson_exn

    let update_cache (cache:Cache.t) t =
        let user = Some t in
        { cache with user }
end

module WebhookUpdate = struct
    type t =
    { channel_id: Channel_id.t
    ; guild_id: Guild_id.t
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.t) _t = cache
end

module Unknown = struct
    type t =
    { kind: string
    ; value: Yojson.Safe.t
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