(** Represents a Map of {!Channel_id.t} keys. *)
module ChannelMap : module type of Map.Make(Channel_id_t)

(** Represents a Map of {!Guild_id.t} keys. *)
module GuildMap : module type of Map.Make(Guild_id_t)

(** Represents a Map of {!User_id.t} keys. *)
module UserMap : module type of Map.Make(User_id_t)

(** The full cache record. Immutable and intended to be wrapped in a concurrency-safe wrapper.
    Channels are split by type so it isn't necessary to match them later on.
*)
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

(** An opaque container around a mutex and cache *)
type t

(** A global t that the lib keeps up to date. You can always keep your own cache with this implementation with {!create}. *)
val cache : t

(** Creates a new, empty cache. *)
val create :
    (* ?max_messages:int -> *)
    unit ->
    t

(** [update t f] locks t and calls f with the internal cache, then writes the result to the cache. *)
val update :
    t ->
    (cache -> cache) ->
    unit Lwt.t

(** [read_copy t] awaits the lock on t, then returns a copy of the internal cache before unlocking. *)
val read_copy :
    t ->
    cache Lwt.t

(** Equivalent to {!GuildMap.find} on cache.guilds. *)
val guild :
    Guild_id_t.t ->
    cache ->
    Guild_t.t option

(** Equivalent to {!ChannelMap.find} on cache.text_channels. *)
val text_channel :
    Channel_id_t.t ->
    cache ->
    Channel_t.guild_text option

(** Equivalent to {!ChannelMap.find} on cache.voice_channels. *)
val voice_channel :
    Channel_id_t.t ->
    cache ->
    Channel_t.guild_voice option

(** Equivalent to {!ChannelMap.find} on cache.categories. *)
val category :
    Channel_id_t.t ->
    cache ->
    Channel_t.category option

(** Equivalent to {!ChannelMap.find} on cache.private_channels. *)
val dm :
    Channel_id_t.t ->
    cache ->
    Channel_t.dm option

(** Equivalent to {!ChannelMap.find} on cache.groups. *)
val group :
    Channel_id_t.t ->
    cache ->
    Channel_t.group option

(** Helper method that scans all channel stores and returns a {!Channel.t} holding the channel. *)
val channel :
    Channel_id_t.t ->
    cache ->
    Channel_t.t option