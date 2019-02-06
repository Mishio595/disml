open Async
open Core

module ChannelMap : module type of Map.Make(Channel_id_t)
module GuildMap : module type of Map.Make(Guild_id_t)
module UserMap : module type of Map.Make(User_id_t)

type t = {
    text_channels: Channel_t.guild_text ChannelMap.t;
    voice_channels: Channel_t.guild_voice ChannelMap.t;
    categories: Channel_t.category ChannelMap.t;
    groups: Channel_t.group ChannelMap.t;
    private_channels: Channel_t.dm ChannelMap.t;
    guilds: Guild_t.t GuildMap.t;
    (* messages: Channel_id_t.t GuildMap.t; *)
    unavailable_guilds: Guild_t.unavailable GuildMap.t;
    user: User_t.t option;
    users: User_t.t UserMap.t;
}

val cache : t Mvar.Read_write.t

val create :
    (* ?max_messages:int -> *)
    unit ->
    t