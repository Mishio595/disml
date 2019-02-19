open Core
open Async

module ChannelMap = Map.Make(Channel_id_t)
module GuildMap = Map.Make(Guild_id_t)
module UserMap = Map.Make(User_id_t)

type t =
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

let create () =
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
    }

let cache =
    let m = Mvar.create () in
    Mvar.set m (create ());
    m

let guild cache = GuildMap.find cache.guilds

let text_channel cache = ChannelMap.find cache.text_channels

let voice_channel cache = ChannelMap.find cache.voice_channels

let category cache = ChannelMap.find cache.categories

let dm cache = ChannelMap.find cache.private_channels

let group cache = ChannelMap.find cache.groups

let channel cache id =
    let check = ChannelMap.find in
    match check cache.text_channels id with
    | Some c -> Some (`GuildText c)
    | None -> (
    match check cache.voice_channels id with
    | Some c -> Some (`GuildVoice c)
    | None -> (
    match check cache.categories id with
    | Some c -> Some (`Category c)
    | None -> (
    match check cache.private_channels id with
    | Some c -> Some (`Private c)
    | None -> (
    match check cache.groups id with
    | Some c -> Some (`Group c)
    | None -> None
    ))))