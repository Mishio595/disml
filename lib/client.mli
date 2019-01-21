open Async

include module type of Client_options
include module type of Dispatch

type t = {
    sharder: Sharder.t;
    token: string;
}

val start : ?count:int -> string -> t Deferred.t

val set_status : status:Yojson.Safe.json -> t -> Sharder.Shard.shard list Deferred.t

val set_status_with : f:(Sharder.Shard.shard -> Yojson.Safe.json) -> t -> Sharder.Shard.shard list Deferred.t

val request_guild_members : guild:Snowflake.t -> ?query:string -> ?limit:int -> t -> Sharder.Shard.shard list Deferred.t