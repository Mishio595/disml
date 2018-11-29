open Async
open Cohttp

module type Token = sig
    val token : string
end

module type Http = sig
    module Base : sig
        exception Invalid_Method

        val base_url : string

        val process_url : string -> Uri.t
        val process_request_body : Yojson.Basic.json -> Cohttp_async.Body.t
        val process_request_headers : unit -> Headers.t

        val process_response :
            Cohttp_async.Response.t * Cohttp_async.Body.t ->
            Yojson.Basic.json

        val request :
            ?body:Yojson.Basic.json ->
            [ `Delete | `Get | `Patch | `Post | `Put ] ->
            string ->
            Yojson.Basic.json Deferred.t
    end

    (* TODO add abstraction sigs *)
end

module type Sharder = sig
    exception Invalid_Payload
    exception Failure_to_Establish_Heartbeat

    type t

    val start :
        ?count:int ->
        string ->
        t Deferred.t

    val set_status :
        status:Yojson.Basic.json ->
        t ->
        (Shard.shard Shard.t) list Deferred.t

    val set_status_with :
        f:(Shard.shard -> Yojson.Basic.json) ->
        t ->
        (Shard.shard Shard.t) list Deferred.t

    val request_guild_members :
        ?query:string ->
        ?count:string ->
        guild:Snowflake.t ->
        t ->
        (Shard.shard Shard.t) list Deferred.t

    module Shard : sig
        type shard
        type 'a t

        val bind :
            f:('a -> unit) ->
            'a t ->
            unit

        val heartbeat :
            shard ->
            shard Deferred.t

        val set_status :
            status:Yojson.Basic.json ->
            shard ->
            shard Deferred.t

        val request_guild_members :
            ?query:string ->
            ?limit:int ->
            guild:Snowflake.t

        val create :
            url:string ->
            shards:int * int ->
            token:string ->
            unit ->
            t Deferred.t
    end
end