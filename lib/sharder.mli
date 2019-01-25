(** Internal sharding manager. Most of this is accessed through {!Client}. *)

open Core
open Async
open Websocket_async

exception Invalid_Payload
exception Failure_to_Establish_Heartbeat

type t

(** Start the Sharder. This is called by {!Client.start}. *)
val start :
    ?count:int ->
    unit ->
    t Deferred.t

(** Module representing a single shard. *)
module Shard : sig
    (** Representation of the state of a shard. *)
    type shard = {
        hb_interval: Time.Span.t Ivar.t; (** Time span between heartbeats, wrapped in an Ivar. *)
        seq: int; (** Current sequence number *)
        session: string option; (** Session id, if one exists. *)
        pipe: Frame.t Pipe.Reader.t * Frame.t Pipe.Writer.t; (** Raw frame IO pipe used for websocket communications. *)
        ready: unit Ivar.t; (** A simple Ivar indicating if the shard has received READY. *)
        url: string; (** The websocket URL in use. *)
        id: int * int; (** A tuple as expected by Discord. First element is the current shard index, second element is the total shard count. *)
        _internal: Reader.t * Writer.t;
    }
    
    (** Wrapper around an internal state, used to wrap {!shard}. *)
    type 'a t = {
        mutable state: 'a;
    }

    (** Send a heartbeat to Discord. This is handled automatically. *)
    val heartbeat :
        shard ->
        shard Deferred.t

    (** Set the status of the shard. *)
    val set_status :
        status:Yojson.Safe.json ->
        shard ->
        shard Deferred.t

    (** Request guild members for the shard's guild. Causes dispatch of multiple {{!Dispatch.members_chunk}member chunk} events. *)
    val request_guild_members :
        ?query:string ->
        ?limit:int ->
        guild:Snowflake.t ->
        shard ->
        shard Deferred.t

    (** Create a new shard *)
    val create :
        url:string ->
        shards:int * int ->
        unit ->
        shard Deferred.t

    val shutdown_clean : shard -> unit Deferred.t
end

(** Calls {!Shard.set_status} for each shard registered with the sharder. *)
val set_status :
    status:Yojson.Safe.json ->
    t ->
    Shard.shard list Deferred.t

(** Like {!set_status} but takes a function with a {{!Shard.shard}shard} as its parameter and {{!Yojson.Safe.json}json} for its return. *)
val set_status_with :
    f:(Shard.shard -> Yojson.Safe.json) ->
    t ->
    Shard.shard list Deferred.t

(** Calls {!Shard.request_guild_members} for each shard registered with the sharder. *)
val request_guild_members :
    ?query:string ->
    ?limit:int ->
    guild:Snowflake.t ->
    t ->
    Shard.shard list Deferred.t

val shutdown_all : t -> unit list Deferred.t