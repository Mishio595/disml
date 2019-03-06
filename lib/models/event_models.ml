let string_of_sexp = Base.String.t_of_sexp
let sexp_of_string = Base.String.sexp_of_t
let option_of_sexp = Base.Option.t_of_sexp
let sexp_of_option = Base.Option.sexp_of_t
let int_of_sexp    = Base.Int.t_of_sexp
let sexp_of_int    = Base.Int.sexp_of_t
let bool_of_sexp   = Base.Bool.t_of_sexp
let sexp_of_bool   = Base.Bool.sexp_of_t
let list_of_sexp   = Base.List.t_of_sexp
let sexp_of_list   = Base.List.sexp_of_t

module ChannelCreate = struct
    type t = Channel_t.t

    let deserialize ev =
        Channel_t.(channel_wrapper_of_yojson_exn ev |> wrap)

    let update_cache (cache:Cache.cache) (t:t) =
        let module C = Cache.ChannelMap in
        match t with
        | `GuildText c ->
            let text_channels = C.update c.id (function
            | Some _ | None -> Some c) cache.text_channels in
            { cache with text_channels }
        | `GuildVoice c ->
            let voice_channels = C.update c.id (function
            | Some _ | None -> Some c) cache.voice_channels in
            { cache with voice_channels }
        | `Category c ->
            let categories = C.update c.id (function
            | Some _ | None -> Some c) cache.categories in
            { cache with categories }
        | `Group c ->
            let groups = C.update c.id (function
            | Some _ | None -> Some c) cache.groups in
            { cache with groups }
        | `Private c ->
            let private_channels = C.update c.id (function
            | Some _ | None -> Some c) cache.private_channels in
            { cache with private_channels }
end

module ChannelDelete = struct
    type t = Channel_t.t

    let deserialize ev =
        Channel_t.(channel_wrapper_of_yojson_exn ev |> wrap)

    let update_cache (cache:Cache.cache) (t:t) =
        let module C = Cache.ChannelMap in
        match t with
        | `GuildText c ->
            let text_channels = C.remove c.id cache.text_channels in
            { cache with text_channels }
        | `GuildVoice c ->
            let voice_channels = C.remove c.id cache.voice_channels in
            { cache with voice_channels }
        | `Category c ->
            let categories = C.remove c.id cache.categories in
            { cache with categories }
        | `Group c ->
            let groups = C.remove c.id cache.groups in
            { cache with groups }
        | `Private c ->
            let private_channels = C.remove c.id cache.private_channels in
            { cache with private_channels }
end

module ChannelUpdate = struct
    type t = Channel_t.t

    let deserialize ev =
        Channel_t.(channel_wrapper_of_yojson_exn ev |> wrap)

    let update_cache (cache:Cache.cache) (t:t) =
        let module C = Cache.ChannelMap in
        match t with
        | `GuildText c ->
            let text_channels = C.update c.id (function
            | Some _ | None -> Some c)
            cache.text_channels in
            { cache with text_channels }
        | `GuildVoice c ->
            let voice_channels = C.update c.id (function
            | Some _ | None -> Some c)
            cache.voice_channels in
            { cache with voice_channels }
        | `Category c ->
            let categories = C.update c.id (function
            | Some _ | None -> Some c)
            cache.categories in
            { cache with categories }
        | `Group c ->
            let groups = C.update c.id (function
            | Some _ | None -> Some c)
            cache.groups in
            { cache with groups }
        | `Private c ->
            let private_channels = C.update c.id (function
            | Some _ | None -> Some c)
            cache.private_channels in
            { cache with private_channels }
end

module ChannelPinsUpdate = struct
    type t =
    { channel_id: Channel_id.t
    ; last_pin_timestamp: string option [@default None]
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.cache) t =
        let module C = Cache.ChannelMap in
        if C.mem t.channel_id cache.private_channels then
            let c = C.find t.channel_id cache.private_channels in
            let private_channels = C.add t.channel_id { c with last_pin_timestamp = t.last_pin_timestamp } cache.private_channels in
            { cache with private_channels }
        else if C.mem t.channel_id cache.text_channels then
            let c = C.find t.channel_id cache.text_channels in
            let text_channels = C.add t.channel_id { c with last_pin_timestamp = t.last_pin_timestamp } cache.text_channels in
            { cache with text_channels }
        else if C.mem t.channel_id cache.groups then
            let c = C.find t.channel_id cache.groups in
            let groups = C.add t.channel_id { c with last_pin_timestamp = t.last_pin_timestamp } cache.groups in
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

    let update_cache (cache:Cache.cache) t = ()
end *)

(* module ChannelRecipientRemove = struct
    type t = {
        channel_id: Channel_id.t;
        user: User_t.t;
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.cache) t = ()
end *)

(* TODO decide on ban caching, if any *)
module GuildBanAdd = struct
    type t =
    { guild_id: Guild_id.t
    ; user: User_t.t
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.cache) _t = cache
end

module GuildBanRemove = struct
    type t =
    { guild_id: Guild_id.t
    ; user: User_t.t
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.cache) _t = cache
end

module GuildCreate = struct
    type t = Guild_t.t

    let deserialize ev =
        Guild_t.(pre_of_yojson_exn ev |> wrap)

    let update_cache (cache:Cache.cache) (t:t) =
        let open Channel_t in
        let module C = Cache.ChannelMap in
        let guilds = Cache.GuildMap.update t.id (function Some _ | None -> Some t) cache.guilds in
        let unavailable_guilds = Cache.GuildMap.remove t.id cache.unavailable_guilds in
        let text, voice, cat = ref [], ref [], ref [] in
        List.iter (function
        | `GuildText (c:guild_text) -> text := (c.id, c) :: !text
        | `GuildVoice (c:guild_voice) -> voice := (c.id, c) :: !voice
        | `Category (c:category) -> cat := (c.id, c) :: !cat
        | _ -> ()) t.channels;
        let text_channels =
            C.of_seq (List.to_seq !text)
            |> C.merge (fun _ left right -> match (left, right) with
            | (Some _, Some c) | (Some c, None) | (None, Some c) -> Some c
            | _ -> None)
            cache.text_channels in
        let voice_channels =
            C.of_seq (List.to_seq !voice)
            |> C.merge (fun _ left right -> match (left, right) with
            | (Some _, Some c) | (Some c, None) | (None, Some c) -> Some c
            | _ -> None)
            cache.voice_channels in
        let categories =
            C.of_seq (List.to_seq !cat)
            |> C.merge (fun _ left right -> match (left, right) with
            | (Some _, Some c) | (Some c, None) | (None, Some c) -> Some c
            | _ -> None)
            cache.categories in
        let users = List.map (fun (m:Member_t.t) -> m.user.id, m.user) t.members in
        let users =
            Cache.UserMap.of_seq (List.to_seq users)
            |> Cache.UserMap.merge (fun _ left right -> match (left, right) with
            | (Some _, Some u) | (Some u, None) | (None, Some u) -> Some u
            | _ -> None)
            cache.users in
        { cache with guilds
        ; unavailable_guilds
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

    let update_cache (cache:Cache.cache) (t:t) =
        let open Channel_t in
        let module G = Cache.GuildMap in
        let module C = Cache.ChannelMap in
        if t.unavailable then
            let guilds = G.remove t.id cache.guilds in
            let unavailable_guilds = G.update t.id (function Some _ | None -> Some t) cache.unavailable_guilds in
            { cache with guilds
            ; unavailable_guilds
            }
        else
        match G.find_opt t.id cache.guilds with
        | Some g ->
            let text_channels = ref cache.text_channels in
            let voice_channels = ref cache.voice_channels in
            let categories = ref cache.categories in
            List.iter (function
                | `GuildText (c:guild_text) -> text_channels := C.remove c.id cache.text_channels
                | `GuildVoice (c:guild_voice) -> voice_channels := C.remove c.id cache.voice_channels
                | `Category (c:category) -> categories := C.remove c.id cache.categories
                | _ -> ()
            ) g.channels;
            let guilds = G.remove g.id cache.guilds in
            let text_channels, voice_channels, categories = !text_channels, !voice_channels, !categories in
            { cache with guilds
            ; text_channels
            ; voice_channels
            ; categories
            }
        | None ->
            let guilds = G.remove t.id cache.guilds in
            { cache with guilds }
end

module GuildUpdate = struct
    type t = Guild_t.t

    let deserialize ev =
        Guild_t.(pre_of_yojson_exn ev |> wrap)

    let update_cache (cache:Cache.cache) t =
        let open Guild_t in
        let {id; _} = t in
        let guilds = Cache.GuildMap.update id (function
            | Some _ | None -> Some t)
            cache.guilds in
        { cache with guilds }
end

module GuildEmojisUpdate = struct
    type t =
    { emojis: Emoji.t list
    ; guild_id: Guild_id.t
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.cache) t =
        let guilds = match Cache.GuildMap.find_opt t.guild_id cache.guilds with
        | Some g -> Cache.GuildMap.add t.guild_id { g with emojis = t.emojis } cache.guilds
        | None -> cache.guilds in
        { cache with guilds }
end

(* TODO guild integrations *)

module GuildMemberAdd = struct
    type t = Member_t.t

    let deserialize = Member_t.of_yojson_exn

    let update_cache (cache:Cache.cache) (t:t) =
        let guilds = match Cache.GuildMap.find_opt t.guild_id cache.guilds with
        | Some g ->
            let members = t :: g.members in
            let data = { g with members } in
            Cache.GuildMap.add t.guild_id data cache.guilds
        | None -> cache.guilds in
        { cache with guilds }
end

module GuildMemberRemove = struct
    type t =
    { guild_id: Guild_id.t
    ; user: User_t.t
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.cache) t =
        let guilds = match Cache.GuildMap.find_opt t.guild_id cache.guilds with
        | Some g ->
            let members = List.filter (fun (m:Member_t.t) -> m.user.id <> t.user.id) g.members in
            let data = { g with members } in
            Cache.GuildMap.add t.guild_id data cache.guilds
        | None -> cache.guilds in
        { cache with guilds }
end

module GuildMemberUpdate = struct
    type t =
    { guild_id: Guild_id.t
    ; nick: string option
    ; roles: Role_id.t list
    ; user: User_t.t
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.cache) t =
        let guilds = match Cache.GuildMap.find_opt t.guild_id cache.guilds with
        | Some g ->
            let members = List.map (fun (m:Member_t.t) ->
                if m.user.id = t.user.id then
                    { m with nick = t.nick; roles = t.roles }
                else m) g.members in
            let data = { g with members } in
            Cache.GuildMap.add t.guild_id data cache.guilds
        | None -> cache.guilds in
        { cache with guilds }
end

module GuildMembersChunk = struct
    type t =
    { guild_id: Guild_id.t
    ; members: Member_t.member list
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.cache) t =
        match Cache.GuildMap.find_opt t.guild_id cache.guilds with
        | None -> cache
        | Some g ->
            let `Guild_id guild_id = t.guild_id in
            let users = List.map (fun (m:Member_t.member) -> m.user.id, m.user) t.members in
            let members = Base.List.filter_map ~f:(fun m ->
                if List.exists (fun (m':Member_t.t) -> m'.user.id <> m.user.id) g.members then
                    Some (Member_t.wrap ~guild_id m)
                else None) t.members in
            let guilds = Cache.GuildMap.add t.guild_id { g with members } cache.guilds in
            let users = 
                Cache.UserMap.of_seq (List.to_seq users)
                |> Cache.UserMap.merge (fun _ left right -> match (left, right) with
                | (Some _, Some u) | (Some u, None) | (None, Some u) -> Some u
                | _ -> None)
                cache.users in
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

    let update_cache (cache:Cache.cache) t =
        let guilds = match Cache.GuildMap.find_opt t.guild_id cache.guilds with
        | Some g ->
            let `Guild_id guild_id = t.guild_id in
            let roles = Role_t.wrap ~guild_id t.role :: g.roles in
            let data = { g with roles } in
            Cache.GuildMap.add t.guild_id data cache.guilds
        | None -> cache.guilds in
        { cache with guilds }
end

module GuildRoleDelete = struct
    type t =
    { guild_id: Guild_id.t
    ; role_id: Role_id.t
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.cache) t =
        let guilds = match Cache.GuildMap.find_opt t.guild_id cache.guilds with
        | Some g ->
            let roles = List.filter (fun (r:Role_t.t) -> r.id <> t.role_id) g.roles in
            let data = { g with roles } in
            Cache.GuildMap.add t.guild_id data cache.guilds
        | None -> cache.guilds in
        { cache with guilds }
end

module GuildRoleUpdate = struct
    type t =
    { guild_id: Guild_id.t
    ; role: Role_t.role
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.cache) t =
        let guilds = match Cache.GuildMap.find_opt t.guild_id cache.guilds with
        | Some g ->
            let `Guild_id guild_id = t.guild_id in
            let roles = List.map (fun (r:Role_t.t) ->
                if r.id = t.role.id then Role_t.wrap ~guild_id t.role else r)
                g.roles in
            let data = { g with roles } in
            Cache.GuildMap.add t.guild_id data cache.guilds
        | None -> cache.guilds in
        { cache with guilds }
end

module MessageCreate = struct
    type t = Message_t.t

    let deserialize =
        Message_t.of_yojson_exn

    let update_cache (cache:Cache.cache) _t = cache
end

module MessageDelete = struct
    type t =
    { id: Message_id.t
    ; channel_id: Channel_id.t
    ; guild_id: Guild_id.t option [@default None]
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.cache) _t = cache
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

    let update_cache (cache:Cache.cache) _t = cache
end

module MessageDeleteBulk = struct
    type t =
    { guild_id: Guild_id.t option [@default None]
    ; channel_id: Channel_id.t
    ; ids: Message_id.t list
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.cache) _t = cache
end

module PresenceUpdate = struct
    type t = Presence.t

    let deserialize = Presence.of_yojson_exn

    let update_cache (cache:Cache.cache) (t:t) =
        let id = t.user.id in
        let presences = Cache.UserMap.add id t cache.presences in
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

    let update_cache (cache:Cache.cache) _t = cache
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

    let update_cache (cache:Cache.cache) _t = cache
end

module ReactionRemoveAll = struct
    type t =
    { channel_id: Channel_id.t
    ; message_id: Message_id.t
    ; guild_id: Guild_id.t option [@default None]
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.cache) _t = cache
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

    let update_cache (cache:Cache.cache) t =
        let unavailable_guilds = 
            List.map (fun (g:Guild_t.unavailable) -> g.id, g) t.guilds
            |> List.to_seq |> Cache.GuildMap.of_seq
            |> Cache.GuildMap.merge (fun _ left right -> match (left, right) with
            | (Some _, Some g) | (Some g, None) | (None, Some g) -> Some g
            |_ -> None)
            cache.unavailable_guilds
        in
        let user = Some t.user in
        { cache with user
        ; unavailable_guilds
        }
end

module Resumed = struct
    type t = { trace: string option list [@key "_trace"] }
    [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.cache) _t = cache
end

module TypingStart = struct
    type t =
    { channel_id: Channel_id.t
    ; guild_id: Guild_id.t option [@default None]
    ; timestamp: int
    ; user_id: User_id.t
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.cache) _t = cache
end

module UserUpdate = struct
    type t = User_t.t

    let deserialize = User_t.of_yojson_exn

    let update_cache (cache:Cache.cache) t =
        let user = Some t in
        { cache with user }
end

module WebhookUpdate = struct
    type t =
    { channel_id: Channel_id.t
    ; guild_id: Guild_id.t
    } [@@deriving sexp, yojson { strict = false; exn = true }]

    let deserialize = of_yojson_exn

    let update_cache (cache:Cache.cache) _t = cache
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
