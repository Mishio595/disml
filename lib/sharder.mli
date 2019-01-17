open Async

exception Invalid_Payload
exception Failure_to_Establish_Heartbeat

type t

val start :
    ?count:int ->
    unit ->
    t Deferred.t

module Shard : sig
    type shard
    type 'a t = {
        mutable state: 'a;
    }

    val heartbeat :
        shard ->
        shard Deferred.t

    val set_status :
        status:Yojson.Safe.json ->
        shard ->
        shard Deferred.t

    val request_guild_members :
        ?query:string ->
        ?limit:int ->
        guild:Snowflake.t ->
        shard ->
        shard Deferred.t

    val create :
        url:string ->
        shards:int * int ->
        unit ->
        shard Deferred.t
end

val set_status :
    status:Yojson.Safe.json ->
    t ->
    Shard.shard list Deferred.t

val set_status_with :
    f:(Shard.shard -> Yojson.Safe.json) ->
    t ->
    Shard.shard list Deferred.t

val request_guild_members :
    ?query:string ->
    ?limit:int ->
    guild:Snowflake.t ->
    t ->
    Shard.shard list Deferred.t