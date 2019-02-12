open Core
open Async

module ChannelMap = Map.Make(Channel_id_t)
module GuildMap = Map.Make(Guild_id_t)
module UserMap = Map.Make(User_id_t)

type t = {
    text_channels: Channel_t.guild_text ChannelMap.t;
    voice_channels: Channel_t.guild_voice ChannelMap.t;
    categories: Channel_t.category ChannelMap.t;
    groups: Channel_t.group ChannelMap.t;
    private_channels: Channel_t.dm ChannelMap.t;
    guilds: Guild_t.t GuildMap.t;
    presences: Presence.t UserMap.t;
    (* messages: Channel_id_t.t GuildMap.t; *)
    unavailable_guilds: Guild_t.unavailable GuildMap.t;
    user: User_t.t option;
    users: User_t.t UserMap.t;
}

let create () = {
    text_channels = ChannelMap.empty;
    voice_channels = ChannelMap.empty;
    categories = ChannelMap.empty;
    groups = ChannelMap.empty;
    private_channels = ChannelMap.empty;
    guilds = GuildMap.empty;
    presences = UserMap.empty;
    unavailable_guilds = GuildMap.empty;
    user = None;
    users = UserMap.empty;
    }

let cache =
    let m = Mvar.create () in
    Mvar.set m (create ());
    m