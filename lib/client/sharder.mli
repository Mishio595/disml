open Async

(**
Record type for registering event handlers
*)
type handler = {
    ready: (Yojson.Basic.json -> unit) option;
    resumed: (Yojson.Basic.json -> unit) option;
    channel_create: (Yojson.Basic.json -> unit) option;
    channel_delete: (Yojson.Basic.json -> unit) option;
    channel_update: (Yojson.Basic.json -> unit) option;
    channel_pins_update: (Yojson.Basic.json -> unit) option;
    guild_create: (Yojson.Basic.json -> unit) option;
    guild_delete: (Yojson.Basic.json -> unit) option;
    guild_update: (Yojson.Basic.json -> unit) option;
    guild_ban_add: (Yojson.Basic.json -> unit) option;
    guild_ban_remove: (Yojson.Basic.json -> unit) option;
    guild_emojis_update: (Yojson.Basic.json -> unit) option;
    guild_integrations_update: (Yojson.Basic.json -> unit) option;
    guild_member_add: (Yojson.Basic.json -> unit) option;
    guild_member_remove: (Yojson.Basic.json -> unit) option;
    guild_member_update: (Yojson.Basic.json -> unit) option;
    guild_members_chunk: (Yojson.Basic.json -> unit) option;
    guild_role_create: (Yojson.Basic.json -> unit) option;
    guild_role_delete: (Yojson.Basic.json -> unit) option;
    guild_role_update: (Yojson.Basic.json -> unit) option;
    message_create: (Yojson.Basic.json -> unit) option;
    message_delete: (Yojson.Basic.json -> unit) option;
    message_update: (Yojson.Basic.json -> unit) option;
    message_delete_bulk: (Yojson.Basic.json -> unit) option;
    message_reaction_add: (Yojson.Basic.json -> unit) option;
    message_reaction_remove: (Yojson.Basic.json -> unit) option;
    message_reaction_remove_all: (Yojson.Basic.json -> unit) option;
    presence_update: (Yojson.Basic.json -> unit) option;
    typing_start: (Yojson.Basic.json -> unit) option;
    user_update: (Yojson.Basic.json -> unit) option;
    voice_state_update: (Yojson.Basic.json -> unit) option;
    voice_server_update: (Yojson.Basic.json -> unit) option;
    webhooks_update: (Yojson.Basic.json -> unit) option;
}

(**
Represents a single Shard. Manual creation is discouraged; use Sharder.start instead
*)
module Shard : sig
    type t = {
        mutable hb: unit Ivar.t option;
        mutable seq: int;
        mutable session: string option;
        mutable handler: handler;
        token: string;
        shard: int * int;
        write: string Pipe.Writer.t;
        read: string Pipe.Reader.t;
        ready: unit Ivar.t;
    }

    val parse :
        [< `Ok of string | `Eof] ->
        Yojson.Basic.json

    val push_frame :
        ?payload:Yojson.Basic.json ->
        t ->
        Opcode.t ->
        t Deferred.t

    val heartbeat :
        t ->
        t Deferred.t

    val dispatch :
        t ->
        Yojson.Basic.json ->
        t Deferred.t

    val set_status :
        t ->
        Yojson.Basic.json ->
        t Deferred.t

    val request_guild_members :
        guild:int ->
        ?query:string ->
        ?limit:int ->
        t ->
        t Deferred.t

    val initialize :
        t ->
        Yojson.Basic.json ->
        t Deferred.t

    val handle_frame :
        t ->
        Yojson.Basic.json ->
        t Deferred.t

    val create :
        url:string ->
        shards:int * int ->
        token:string ->
        handler: handler ->
        unit ->
        t Deferred.t
end

type t = {
    shards: Shard.t list;
}

val start :
    ?count:int ->
    handler:handler ->
    string ->
    t Deferred.t

val set_status :
    t ->
    Yojson.Basic.json ->
    Shard.t list Deferred.t

val set_status_with :
    t ->
    (Shard.t -> Yojson.Basic.json) ->
    Shard.t list Deferred.t

val request_guild_members :
    guild:int ->
    ?query:string ->
    ?limit:int ->
    t ->
    Shard.t list Deferred.t

val update_handler :
    t ->
    handler ->
    unit