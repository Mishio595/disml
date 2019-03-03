(** Internal sharding manager. Most of this is accessed through {!Client}. *)

open Websocket

exception Invalid_Payload
exception Failure_to_Establish_Heartbeat

type t

(** Start the Sharder. This is called by {!Client.start}. *)
val start :
    ?count:int ->
    ?compress:bool ->
    ?large_threshold:int ->
    unit ->
    t Lwt.t

(** Module representing a single shard. *)
module Shard : sig
    (** Representation of the state of a shard. *)
    type shard =
    { compress: bool (** Whether to compress payloads. *)
    ; hb_interval: int Lwt.t * int Lwt.u (** Time between heartbeats. Not known until HELLO is received. *)
    ; hb_stopper: unit Lwt.t * unit Lwt.u (** Stops the heartbeat sequencing when filled *)
    ; id: int (** ID of the current shard. Must be less than shard_count. *)
    ; large_threshold: int (** Minimum number of members needed for a guild to be considered large. *)
    ; ready: unit Lwt.t * unit Lwt.u (** A simple promise indicating if the shard has received READY. *)
    ; recv: Frame.t Lwt_stream.t (** Receiver function for the websocket. *)
    ; send: (Frame.t -> unit Lwt.t) (** Sender function for the websocket. *)
    ; seq: int (** Current sequence number for the session. *)
    ; session: string option (** Current session ID *)
    ; shard_count: int (** Total number of shards. *)
    ; url: string (** The websocket URL. *)
    }

    (** Wrapper around an internal state, used to wrap {!shard}. *)
    type 'a t = {
        mutable state: 'a;
        mutable stopped: bool;
        mutable can_resume: bool;
    }

    (** Send a heartbeat to Discord. This is handled automatically. *)
    val heartbeat :
        shard ->
        shard Lwt.t

    (** Set the status of the shard. *)
    val set_status :
        ?status:string ->
        ?kind:int ->
        ?name:string ->
        ?since:int ->
        ?url:string ->
        shard ->
        shard Lwt.t

    (** Request guild members for the shard's guild. Causes dispatch of multiple {{!Dispatch.members_chunk}member chunk} events. *)
    val request_guild_members :
        ?query:string ->
        ?limit:int ->
        guild:Snowflake.t ->
        shard ->
        shard Lwt.t

    (** Create a new shard *)
    val create :
        url:string ->
        shards:int * int ->
        ?compress:bool ->
        ?large_threshold:int ->
        unit ->
        shard Lwt.t

    val shutdown :
        ?clean:bool ->
        ?restart:bool ->
        shard t ->
        unit Lwt.t
end

(** Calls {!Shard.set_status} for each shard registered with the sharder. *)
val set_status :
    ?status:string ->
    ?kind:int ->
    ?name:string ->
    ?since:int ->
    ?url:string ->
    t ->
    unit Lwt.t

(** Calls {!Shard.request_guild_members} for each shard registered with the sharder. *)
val request_guild_members :
    ?query:string ->
    ?limit:int ->
    guild:Snowflake.t ->
    t ->
    unit Lwt.t

val shutdown_all :
    ?restart:bool ->
    t ->
    unit Lwt.t
