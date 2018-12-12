open Async

module type Token = sig
    val token : string
end

module type Client = sig
    type context
end

module type Handler = sig
    val handle_event :
        'a ->
        'b ->
        unit
end

module type Http = sig
    val token : string

    module Base : sig
        exception Invalid_Method

        val base_url : string

        val process_url : string -> Uri.t
        val process_request_body : Yojson.Safe.json -> Cohttp_async.Body.t
        val process_request_headers : unit -> Cohttp.Header.t

        val process_response :
            Cohttp_async.Response.t * Cohttp_async.Body.t ->
            Yojson.Safe.json Deferred.t

        val request :
            ?body:Yojson.Safe.json ->
            [> `DELETE | `GET | `PATCH | `POST | `PUT ] ->
            string ->
            Yojson.Safe.json Deferred.t
    end

    (* Auto-generated signatures *)
    val get_gateway : unit -> Yojson.Safe.json Async.Deferred.t
    val get_gateway_bot : unit -> Yojson.Safe.json Async.Deferred.t
    val get_channel : string -> Yojson.Safe.json Async.Deferred.t
    val modify_channel :
      string -> Yojson.Safe.json -> Yojson.Safe.json Async.Deferred.t
    val delete_channel : string -> Yojson.Safe.json Async.Deferred.t
    val get_messages : string -> Yojson.Safe.json Async.Deferred.t
    val get_message : string -> string -> Yojson.Safe.json Async.Deferred.t
    val create_message :
      string -> Yojson.Safe.json -> Yojson.Safe.json Async.Deferred.t
    val create_reaction :
      string -> string -> string -> Yojson.Safe.json Async.Deferred.t
    val delete_own_reaction :
      string -> string -> string -> Yojson.Safe.json Async.Deferred.t
    val delete_reaction :
      string ->
      string -> string -> string -> Yojson.Safe.json Async.Deferred.t
    val get_reactions :
      string -> string -> string -> Yojson.Safe.json Async.Deferred.t
    val delete_reactions :
      string -> string -> Yojson.Safe.json Async.Deferred.t
    val edit_message :
      string ->
      string -> Yojson.Safe.json -> Yojson.Safe.json Async.Deferred.t
    val delete_message :
      string -> string -> Yojson.Safe.json Async.Deferred.t
    val bulk_delete :
      string -> Yojson.Safe.json -> Yojson.Safe.json Async.Deferred.t
    val edit_channel_permissions :
      string ->
      string -> Yojson.Safe.json -> Yojson.Safe.json Async.Deferred.t
    val get_channel_invites : string -> Yojson.Safe.json Async.Deferred.t
    val create_channel_invite :
      string -> Yojson.Safe.json -> Yojson.Safe.json Async.Deferred.t
    val delete_channel_permission :
      string -> string -> Yojson.Safe.json Async.Deferred.t
    val broadcast_typing : string -> Yojson.Safe.json Async.Deferred.t
    val get_pinned_messages : string -> Yojson.Safe.json Async.Deferred.t
    val pin_message : string -> string -> Yojson.Safe.json Async.Deferred.t
    val unpin_message :
      string -> string -> Yojson.Safe.json Async.Deferred.t
    val group_recipient_add :
      string -> string -> Yojson.Safe.json Async.Deferred.t
    val group_recipient_remove :
      string -> string -> Yojson.Safe.json Async.Deferred.t
    val get_emojis : string -> Yojson.Safe.json Async.Deferred.t
    val get_emoji : string -> string -> Yojson.Safe.json Async.Deferred.t
    val create_emoji :
      string -> Yojson.Safe.json -> Yojson.Safe.json Async.Deferred.t
    val edit_emoji :
      string ->
      string -> Yojson.Safe.json -> Yojson.Safe.json Async.Deferred.t
    val delete_emoji : string -> string -> Yojson.Safe.json Async.Deferred.t
    val create_guild :
      Yojson.Safe.json -> Yojson.Safe.json Async.Deferred.t
    val get_guild : string -> Yojson.Safe.json Async.Deferred.t
    val edit_guild :
      string -> Yojson.Safe.json -> Yojson.Safe.json Async.Deferred.t
    val delete_guild : string -> Yojson.Safe.json Async.Deferred.t
    val get_guild_channels : string -> Yojson.Safe.json Async.Deferred.t
    val create_guild_channel :
      string -> Yojson.Safe.json -> Yojson.Safe.json Async.Deferred.t
    val modify_guild_channel_positions :
      string -> Yojson.Safe.json -> Yojson.Safe.json Async.Deferred.t
    val get_member : string -> string -> Yojson.Safe.json Async.Deferred.t
    val get_members : string -> Yojson.Safe.json Async.Deferred.t
    val add_member :
      string ->
      string -> Yojson.Safe.json -> Yojson.Safe.json Async.Deferred.t
    val edit_member :
      string ->
      string -> Yojson.Safe.json -> Yojson.Safe.json Async.Deferred.t
    val remove_member :
      string -> string -> Yojson.Safe.json Async.Deferred.t
    val change_nickname :
      string -> Yojson.Safe.json -> Yojson.Safe.json Async.Deferred.t
    val add_member_role :
      string -> string -> string -> Yojson.Safe.json Async.Deferred.t
    val remove_member_role :
      string -> string -> string -> Yojson.Safe.json Async.Deferred.t
    val get_bans : string -> Yojson.Safe.json Async.Deferred.t
    val get_ban : string -> string -> Yojson.Safe.json Async.Deferred.t
    val guild_ban_add :
      string ->
      string -> Yojson.Safe.json -> Yojson.Safe.json Async.Deferred.t
    val guild_ban_remove :
      string -> string -> Yojson.Safe.json Async.Deferred.t
    val get_roles : string -> Yojson.Safe.json Async.Deferred.t
    val guild_role_add :
      string -> Yojson.Safe.json -> Yojson.Safe.json Async.Deferred.t
    val guild_roles_edit :
      string -> Yojson.Safe.json -> Yojson.Safe.json Async.Deferred.t
    val guild_role_edit :
      string ->
      string -> Yojson.Safe.json -> Yojson.Safe.json Async.Deferred.t
    val guild_role_remove :
      string -> string -> Yojson.Safe.json Async.Deferred.t
    val guild_prune_count : string -> Yojson.Safe.json Async.Deferred.t
    val guild_prune_start :
      string -> Yojson.Safe.json -> Yojson.Safe.json Async.Deferred.t
    val get_guild_voice_regions :
      string -> Yojson.Safe.json Async.Deferred.t
    val get_guild_invites : string -> Yojson.Safe.json Async.Deferred.t
    val get_integrations : string -> Yojson.Safe.json Async.Deferred.t
    val add_integration :
      string -> Yojson.Safe.json -> Yojson.Safe.json Async.Deferred.t
    val edit_integration :
      string ->
      string -> Yojson.Safe.json -> Yojson.Safe.json Async.Deferred.t
    val delete_integration :
      string -> string -> Yojson.Safe.json Async.Deferred.t
    val sync_integration :
      string -> string -> Yojson.Safe.json Async.Deferred.t
    val get_guild_embed : string -> Yojson.Safe.json Async.Deferred.t
    val edit_guild_embed :
      string -> Yojson.Safe.json -> Yojson.Safe.json Async.Deferred.t
    val get_vanity_url : string -> Yojson.Safe.json Async.Deferred.t
    val get_invite : string -> Yojson.Safe.json Async.Deferred.t
    val delete_invite : string -> Yojson.Safe.json Async.Deferred.t
    val get_current_user : unit -> Yojson.Safe.json Async.Deferred.t
    val edit_current_user :
      Yojson.Safe.json -> Yojson.Safe.json Async.Deferred.t
    val get_guilds : unit -> Yojson.Safe.json Async.Deferred.t
    val leave_guild : string -> Yojson.Safe.json Async.Deferred.t
    val get_private_channels : unit -> Yojson.Safe.json Async.Deferred.t
    val create_dm : Yojson.Safe.json -> Yojson.Safe.json Async.Deferred.t
    val create_group_dm :
      Yojson.Safe.json -> Yojson.Safe.json Async.Deferred.t
    val get_connections : unit -> Yojson.Safe.json Async.Deferred.t
    val get_user : string -> Yojson.Safe.json Async.Deferred.t
    val get_voice_regions : unit -> Yojson.Safe.json Async.Deferred.t
    val create_webhook :
      string -> Yojson.Safe.json -> Yojson.Safe.json Async.Deferred.t
    val get_channel_webhooks : string -> Yojson.Safe.json Async.Deferred.t
    val get_guild_webhooks : string -> Yojson.Safe.json Async.Deferred.t
    val get_webhook : string -> Yojson.Safe.json Async.Deferred.t
    val get_webhook_with_token :
      string -> string -> Yojson.Safe.json Async.Deferred.t
    val edit_webhook :
      string -> Yojson.Safe.json -> Yojson.Safe.json Async.Deferred.t
    val edit_webhook_with_token :
      string ->
      string -> Yojson.Safe.json -> Yojson.Safe.json Async.Deferred.t
    val delete_webhook : string -> Yojson.Safe.json Async.Deferred.t
    val delete_webhook_with_token :
      string -> string -> Yojson.Safe.json Async.Deferred.t
    val execute_webhook :
      string ->
      string -> Yojson.Safe.json -> Yojson.Safe.json Async.Deferred.t
    val execute_slack_webhook :
      string ->
      string -> Yojson.Safe.json -> Yojson.Safe.json Async.Deferred.t
    val execute_git_webhook :
      string ->
      string -> Yojson.Safe.json -> Yojson.Safe.json Async.Deferred.t
    val get_audit_logs :
      string -> Yojson.Safe.json -> Yojson.Safe.json Async.Deferred.t
end

module type Sharder = sig
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
            mutable binds: ('a -> unit) list;
        }

        val bind :
            f:('a -> unit) ->
            'a t ->
            unit

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
end