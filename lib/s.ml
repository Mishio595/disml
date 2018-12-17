open Async

module type Token = sig
    val token : string
end

module type Activity = sig end

module type Attachment = sig end

module type Ban = sig end

module type Channel = sig end

module type Embed = sig end

module type Emoji = sig end

module type Guild = sig
    val ban_user : id:Snowflake_t.t -> ?reason:string -> ?days:int -> Guild_t.t -> string Deferred.Or_error.t
    val create_emoji : name:string -> image:string -> Guild_t.t -> string Deferred.Or_error.t
    val create_role :
        name:string ->
        ?colour:int ->
        ?permissions:int ->
        ?hoist:bool ->
        ?mentionable:bool ->
        Guild_t.t ->
        string Deferred.Or_error.t
    val create_channel : mode:[ `Text | `Voice | `Category ] -> name:string -> Guild_t.t -> string Deferred.Or_error.t
    val delete : Guild_t.t -> string Deferred.Or_error.t
    val get_ban : id:Snowflake_t.t -> Guild_t.t -> string Deferred.Or_error.t
    val get_bans : Guild_t.t -> string Deferred.Or_error.t
    val get_channel : id:Snowflake_t.t -> Guild_t.t -> Channel_t.t Deferred.Or_error.t
    val get_emoji : id:Snowflake_t.t -> Guild_t.t -> string Deferred.Or_error.t
    val get_invites : Guild_t.t -> string Deferred.Or_error.t
    val get_member : id:Snowflake_t.t -> Guild_t.t -> Member_t.t Deferred.Or_error.t
    val get_prune_count : days:int -> Guild_t.t -> string Deferred.Or_error.t
    val get_role : id:Snowflake_t.t -> Guild_t.t -> Role_t.t option
    val get_webhooks : Guild_t.t -> string Deferred.Or_error.t
    val kick_user : id:Snowflake_t.t -> ?reason:string -> Guild_t.t -> string Deferred.Or_error.t
    val leave : Guild_t.t -> string Deferred.Or_error.t
    val list_voice_regions : Guild_t.t -> string Deferred.Or_error.t
    val prune : days:int -> Guild_t.t -> string Deferred.Or_error.t
    val request_members : Guild_t.t -> string Deferred.Or_error.t
    val set_afk_channel : id:Snowflake_t.t -> Guild_t.t -> string Deferred.Or_error.t
    val set_afk_timeout : timeout:int -> Guild_t.t -> string Deferred.Or_error.t
    val set_name : name:string -> Guild_t.t -> string Deferred.Or_error.t
    val set_icon : icon:string -> Guild_t.t -> string Deferred.Or_error.t
    val unban_user : id:Snowflake_t.t -> ?reason:string -> Guild_t.t -> string Deferred.Or_error.t
end

module type Member = sig
    (* val add_role : Member_t.t -> Role_t.t -> string Deferred.Or_error.t
    val remove_role : Member_t.t -> Role_t.t -> string Deferred.Or_error.t
    val ban : ?reason:string -> ?days:int -> Member_t.t -> string Deferred.Or_error.t
    val ban : ?reason:string -> Member_t.t -> string Deferred.Or_error.t
    val kick : ?reason:string -> Member_t.t -> string Deferred.Or_error.t
    val mute : Member_t.t -> string Deferred.Or_error.t
    val deafen : Member_t.t -> string Deferred.Or_error.t
    val unmute : Member_t.t -> string Deferred.Or_error.t
    val undeafen : Member_t.t -> string Deferred.Or_error.t *)
end

module type Message = sig
    val add_reaction : Message_t.t -> Emoji_t.t -> string Deferred.Or_error.t
    val remove_reaction : Message_t.t -> Emoji_t.t -> User_t.t -> string Deferred.Or_error.t
    val clear_reactions : Message_t.t -> string Deferred.Or_error.t
    val delete : Message_t.t -> string Deferred.Or_error.t
    val pin : Message_t.t -> string Deferred.Or_error.t
    val unpin : Message_t.t -> string Deferred.Or_error.t
    val reply : Message_t.t -> string -> string Deferred.Or_error.t
    val set_content : Message_t.t -> string -> string Deferred.Or_error.t
    val set_embed : Message_t.t -> Embed_t.t -> string Deferred.Or_error.t
end

module type Presence = sig end

module type Reaction = sig end

module type Role = sig
    val allow_mention : Role_t.t -> string Deferred.Or_error.t
    val delete : Role_t.t -> string Deferred.Or_error.t
    val disallow_mention : Role_t.t -> string Deferred.Or_error.t
    val hoist : Role_t.t -> string Deferred.Or_error.t
    val set_colour : colour:int -> Role_t.t -> string Deferred.Or_error.t
    val set_name : name:string -> Role_t.t -> string Deferred.Or_error.t
    val unhoist : Role_t.t -> string Deferred.Or_error.t
end

module type Snowflake = sig
    val timestamp : Snowflake_t.t -> int
    val timestamp_iso : Snowflake_t.t -> string
end

module type User = sig
    val tag : User_t.t -> string
    val mention : User_t.t -> string
    val default_avatar : User_t.t -> string
    val face : User_t.t -> string
    (* val private_channel : User_t.t -> Channel_t.t *)
    (* val send : User_t.t -> string Deferred.Or_error.t *)
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
            string ->
            Cohttp_async.Response.t * Cohttp_async.Body.t ->
            string Deferred.Or_error.t

        val request :
            ?body:Yojson.Safe.json ->
            [> `DELETE | `GET | `PATCH | `POST | `PUT ] ->
            string ->
            string Deferred.Or_error.t
    end

    (* Auto-generated signatures *)
    val get_gateway : unit -> string Core.Or_error.t Conduit_async.io
    val get_gateway_bot : unit -> string Core.Or_error.t Conduit_async.io
    val get_channel : int -> string Core.Or_error.t Conduit_async.io
    val modify_channel :
      int -> Yojson.Safe.json -> string Core.Or_error.t Conduit_async.io
    val delete_channel : int -> string Core.Or_error.t Conduit_async.io
    val get_messages : int -> string Core.Or_error.t Conduit_async.io
    val get_message : int -> int -> string Core.Or_error.t Conduit_async.io
    val create_message :
      int -> Yojson.Safe.json -> string Core.Or_error.t Conduit_async.io
    val create_reaction :
      int -> int -> string -> string Core.Or_error.t Conduit_async.io
    val delete_own_reaction :
      int -> int -> string -> string Core.Or_error.t Conduit_async.io
    val delete_reaction :
      int -> int -> string -> int -> string Core.Or_error.t Conduit_async.io
    val get_reactions :
      int -> int -> string -> string Core.Or_error.t Conduit_async.io
    val delete_reactions :
      int -> int -> string Core.Or_error.t Conduit_async.io
    val edit_message :
      int ->
      int -> Yojson.Safe.json -> string Core.Or_error.t Conduit_async.io
    val delete_message :
      int -> int -> string Core.Or_error.t Conduit_async.io
    val bulk_delete :
      int -> Yojson.Safe.json -> string Core.Or_error.t Conduit_async.io
    val edit_channel_permissions :
      int ->
      int -> Yojson.Safe.json -> string Core.Or_error.t Conduit_async.io
    val get_channel_invites : int -> string Core.Or_error.t Conduit_async.io
    val create_channel_invite :
      int -> Yojson.Safe.json -> string Core.Or_error.t Conduit_async.io
    val delete_channel_permission :
      int -> int -> string Core.Or_error.t Conduit_async.io
    val broadcast_typing : int -> string Core.Or_error.t Conduit_async.io
    val get_pinned_messages : int -> string Core.Or_error.t Conduit_async.io
    val pin_message : int -> int -> string Core.Or_error.t Conduit_async.io
    val unpin_message : int -> int -> string Core.Or_error.t Conduit_async.io
    val group_recipient_add :
      int -> int -> string Core.Or_error.t Conduit_async.io
    val group_recipient_remove :
      int -> int -> string Core.Or_error.t Conduit_async.io
    val get_emojis : int -> string Core.Or_error.t Conduit_async.io
    val get_emoji : int -> int -> string Core.Or_error.t Conduit_async.io
    val create_emoji :
      int -> Yojson.Safe.json -> string Core.Or_error.t Conduit_async.io
    val edit_emoji :
      int ->
      int -> Yojson.Safe.json -> string Core.Or_error.t Conduit_async.io
    val delete_emoji : int -> int -> string Core.Or_error.t Conduit_async.io
    val create_guild :
      Yojson.Safe.json -> string Core.Or_error.t Conduit_async.io
    val get_guild : int -> string Core.Or_error.t Conduit_async.io
    val edit_guild :
      int -> Yojson.Safe.json -> string Core.Or_error.t Conduit_async.io
    val delete_guild : int -> string Core.Or_error.t Conduit_async.io
    val get_guild_channels : int -> string Core.Or_error.t Conduit_async.io
    val create_guild_channel :
      int -> Yojson.Safe.json -> string Core.Or_error.t Conduit_async.io
    val modify_guild_channel_positions :
      int -> Yojson.Safe.json -> string Core.Or_error.t Conduit_async.io
    val get_member : int -> int -> string Core.Or_error.t Conduit_async.io
    val get_members : int -> string Core.Or_error.t Conduit_async.io
    val add_member :
      int ->
      int -> Yojson.Safe.json -> string Core.Or_error.t Conduit_async.io
    val edit_member :
      int ->
      int -> Yojson.Safe.json -> string Core.Or_error.t Conduit_async.io
    val remove_member :
      int ->
      int -> Yojson.Safe.json -> string Core.Or_error.t Conduit_async.io
    val change_nickname :
      int -> Yojson.Safe.json -> string Core.Or_error.t Conduit_async.io
    val add_member_role :
      int -> int -> int -> string Core.Or_error.t Conduit_async.io
    val remove_member_role :
      int -> int -> int -> string Core.Or_error.t Conduit_async.io
    val get_bans : int -> string Core.Or_error.t Conduit_async.io
    val get_ban : int -> int -> string Core.Or_error.t Conduit_async.io
    val guild_ban_add :
      int ->
      int -> Yojson.Safe.json -> string Core.Or_error.t Conduit_async.io
    val guild_ban_remove :
      int ->
      int -> Yojson.Safe.json -> string Core.Or_error.t Conduit_async.io
    val get_roles : int -> string Core.Or_error.t Conduit_async.io
    val guild_role_add :
      int -> Yojson.Safe.json -> string Core.Or_error.t Conduit_async.io
    val guild_roles_edit :
      int -> Yojson.Safe.json -> string Core.Or_error.t Conduit_async.io
    val guild_role_edit :
      int ->
      int -> Yojson.Safe.json -> string Core.Or_error.t Conduit_async.io
    val guild_role_remove :
      int -> int -> string Core.Or_error.t Conduit_async.io
    val guild_prune_count :
      int -> int -> string Core.Or_error.t Conduit_async.io
    val guild_prune_start :
      int -> int -> string Core.Or_error.t Conduit_async.io
    val get_guild_voice_regions :
      int -> string Core.Or_error.t Conduit_async.io
    val get_guild_invites : int -> string Core.Or_error.t Conduit_async.io
    val get_integrations : int -> string Core.Or_error.t Conduit_async.io
    val add_integration :
      int -> Yojson.Safe.json -> string Core.Or_error.t Conduit_async.io
    val edit_integration :
      int ->
      int -> Yojson.Safe.json -> string Core.Or_error.t Conduit_async.io
    val delete_integration :
      int -> int -> string Core.Or_error.t Conduit_async.io
    val sync_integration :
      int -> int -> string Core.Or_error.t Conduit_async.io
    val get_guild_embed : int -> string Core.Or_error.t Conduit_async.io
    val edit_guild_embed :
      int -> Yojson.Safe.json -> string Core.Or_error.t Conduit_async.io
    val get_vanity_url : int -> string Core.Or_error.t Conduit_async.io
    val get_invite : string -> string Core.Or_error.t Conduit_async.io
    val delete_invite : string -> string Core.Or_error.t Conduit_async.io
    val get_current_user : unit -> string Core.Or_error.t Conduit_async.io
    val edit_current_user :
      Yojson.Safe.json -> string Core.Or_error.t Conduit_async.io
    val get_guilds : unit -> string Core.Or_error.t Conduit_async.io
    val leave_guild : int -> string Core.Or_error.t Conduit_async.io
    val get_private_channels :
      unit -> string Core.Or_error.t Conduit_async.io
    val create_dm :
      Yojson.Safe.json -> string Core.Or_error.t Conduit_async.io
    val create_group_dm :
      Yojson.Safe.json -> string Core.Or_error.t Conduit_async.io
    val get_connections : unit -> string Core.Or_error.t Conduit_async.io
    val get_user : int -> string Core.Or_error.t Conduit_async.io
    val get_voice_regions : unit -> string Core.Or_error.t Conduit_async.io
    val create_webhook :
      int -> Yojson.Safe.json -> string Core.Or_error.t Conduit_async.io
    val get_channel_webhooks : int -> string Core.Or_error.t Conduit_async.io
    val get_guild_webhooks : int -> string Core.Or_error.t Conduit_async.io
    val get_webhook : int -> string Core.Or_error.t Conduit_async.io
    val get_webhook_with_token :
      int -> string -> string Core.Or_error.t Conduit_async.io
    val edit_webhook :
      int -> Yojson.Safe.json -> string Core.Or_error.t Conduit_async.io
    val edit_webhook_with_token :
      int ->
      string -> Yojson.Safe.json -> string Core.Or_error.t Conduit_async.io
    val delete_webhook : int -> string Core.Or_error.t Conduit_async.io
    val delete_webhook_with_token :
      int -> string -> string Core.Or_error.t Conduit_async.io
    val execute_webhook :
      int ->
      string -> Yojson.Safe.json -> string Core.Or_error.t Conduit_async.io
    val execute_slack_webhook :
      int ->
      string -> Yojson.Safe.json -> string Core.Or_error.t Conduit_async.io
    val execute_git_webhook :
      int ->
      string -> Yojson.Safe.json -> string Core.Or_error.t Conduit_async.io
    val get_audit_logs :
      int -> Yojson.Safe.json -> string Core.Or_error.t Conduit_async.io
end

module type Models = sig
	module Http : Http
    module Activity : Activity
    module Attachment : Attachment
    module Ban : Ban
    module Channel : Channel
    module Embed : Embed
    module Emoji : Emoji
    module Guild : Guild
    module Member : Member
    module Message : Message
    module Presence : Presence
    module Reaction : Reaction
    module Role : Role
    module Snowflake : Snowflake
    module User : User
end

module type Handler = sig
    val handle_event :
        Event.t ->
        unit
end

module type Handler_f = sig
    module Make(Models : Models) : Handler
end

module type Dispatch = sig
    val dispatch : ev:string -> string -> unit
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
            guild:Snowflake_t.t ->
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
        guild:Snowflake_t.t ->
        t ->
        Shard.shard list Deferred.t
end