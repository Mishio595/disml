open Async
open Core

(** Represents a Map of {!Channel_id.t} keys. *)
module ChannelMap : module type of Map.Make(Channel_id_t)

(** Represents a Map of {!Guild_id.t} keys. *)
module GuildMap : module type of Map.Make(Guild_id_t)

(** Represents a Map of {!User_id.t} keys. *)
module UserMap : module type of Map.Make(User_id_t)

(** The full cache record. Immutable and intended to be wrapped in a concurrency-safe wrapper such as {{!Async.Mvar.Read_write.t}Mvar}. *)
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

(** A {{!t}cache} wrapped in an {{!Async.Mvar.Read_write.t}Mvar}. *)
val cache : t Mvar.Read_write.t

(** Creates a new, empty cache. *)
val create :
    (* ?max_messages:int -> *)
    unit ->
    t