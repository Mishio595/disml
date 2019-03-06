module ChannelMap = Map.Make(Channel_id_t)
module GuildMap = Map.Make(Guild_id_t)
module UserMap = Map.Make(User_id_t)

type cache =
{ text_channels: Channel_t.guild_text ChannelMap.t
; voice_channels: Channel_t.guild_voice ChannelMap.t
; categories: Channel_t.category ChannelMap.t
; groups: Channel_t.group ChannelMap.t
; private_channels: Channel_t.dm ChannelMap.t
; guilds: Guild_t.t GuildMap.t
; presences: Presence.t UserMap.t
(* ; messages: Channel_id_t.t GuildMap.t *)
; unavailable_guilds: Guild_t.unavailable GuildMap.t
; user: User_t.t option
; users: User_t.t UserMap.t
}

type t =
{ lock: Lwt_mutex.t
; mutable cache: cache
}

let create () =
    let lock = Lwt_mutex.create () in
    let cache =
        { text_channels = ChannelMap.empty
        ; voice_channels = ChannelMap.empty
        ; categories = ChannelMap.empty
        ; groups = ChannelMap.empty
        ; private_channels = ChannelMap.empty
        ; guilds = GuildMap.empty
        ; presences = UserMap.empty
        ; unavailable_guilds = GuildMap.empty
        ; user = None
        ; users = UserMap.empty
        } in
    { lock; cache }

let cache = create ()

let update ({lock; cache} as t) f =
    Lwt_mutex.with_lock lock (fun () -> 
        let cache = f cache in
        t.cache <- cache;
        Lwt.return_unit)

let read_copy {lock; cache} =
    Lwt_mutex.with_lock lock (fun () -> Lwt.return cache)

let guild k cache = GuildMap.find_opt k cache.guilds

let text_channel k cache = ChannelMap.find_opt k cache.text_channels

let voice_channel k cache = ChannelMap.find_opt k cache.voice_channels

let category k cache = ChannelMap.find_opt k cache.categories

let dm k cache = ChannelMap.find_opt k cache.private_channels

let group k cache = ChannelMap.find_opt k cache.groups

let channel id cache : Channel_t.t option =
    let check = ChannelMap.find_opt in
    match check id cache.text_channels with
    | Some c -> Some (`GuildText c)
    | None -> (
    match check id cache.voice_channels with
    | Some c -> Some (`GuildVoice c)
    | None -> (
    match check id cache.categories with
    | Some c -> Some (`Category c)
    | None -> (
    match check id cache.private_channels with
    | Some c -> Some (`Private c)
    | None -> (
    match check id cache.groups with
    | Some c -> Some (`Group c)
    | None -> None
    ))))