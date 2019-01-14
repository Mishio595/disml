open Async

module type ClientOptions = sig
    val token : string
end

module type Message = sig
    type t = Message_t.t
    val add_reaction : t -> Emoji.t -> Yojson.Safe.json Deferred.Or_error.t
    val remove_reaction : t -> Emoji.t -> User_t.t -> Yojson.Safe.json Deferred.Or_error.t
    val clear_reactions : t -> Yojson.Safe.json Deferred.Or_error.t
    val delete : t -> Yojson.Safe.json Deferred.Or_error.t
    val pin : t -> Yojson.Safe.json Deferred.Or_error.t
    val unpin : t -> Yojson.Safe.json Deferred.Or_error.t
    val reply : t -> string -> Yojson.Safe.json Deferred.Or_error.t
    val set_content : t -> string -> Yojson.Safe.json Deferred.Or_error.t
    val set_embed : t -> Embed.t -> Yojson.Safe.json Deferred.Or_error.t
end

module type Ban = sig
    type t = Ban_t.t
end

module type Channel = sig
    type t = Channel_t.t
    val say : content:string -> t -> Message_t.t Deferred.Or_error.t
    val send_message :
        ?embed:Yojson.Safe.json ->
        ?content:string ->
        ?file:string ->
        ?tts:bool ->
        t ->
        Message_t.t Deferred.Or_error.t
    val delete : t -> unit Deferred.Or_error.t
    val get_message : id:Snowflake.t -> t -> Message_t.t Deferred.Or_error.t
    val get_messages :
        ?mode:[ `Before | `After | `Around ] ->
        ?id:Snowflake.t ->
        ?limit:int ->
        t ->
        Message_t.t list Deferred.Or_error.t
    val broadcast_typing : t -> unit Deferred.Or_error.t
    val get_pins : t -> Message_t.t list Deferred.Or_error.t
    (* TODO more things related to guild channels *)
end

module type Member = sig
    type t = Member_t.t
    val add_role : role:Role_t.t -> Member_t.t -> unit Deferred.Or_error.t
    val remove_role : role:Role_t.t -> Member_t.t -> unit Deferred.Or_error.t
    val ban : ?reason:string -> ?days:int -> Member_t.t -> unit Deferred.Or_error.t
    val kick : ?reason:string -> Member_t.t -> unit Deferred.Or_error.t
    val deafen : Member_t.t -> unit Deferred.Or_error.t
    val unmute : Member_t.t -> unit Deferred.Or_error.t
    val undeafen : Member_t.t -> unit Deferred.Or_error.t
end

module type Reaction = sig
    type t = Reaction_t.t
    (* val delete : Reaction_t.t -> Yojson.Safe.json Deferred.Or_error.t
    val get_users : Reaction_t.t -> int -> User_t.t list Deferred.Or_error.t
    val get_users_after : Reaction_t.t -> Snowflake.t -> int -> User_t.t list Deferred.Or_error.t
    val get_users_before : Reaction_t.t -> Snowflake.t -> int -> User_t.t list Deferred.Or_error.t *)
end

module type Role = sig
    type t = Role_t.t
    val allow_mention : t -> Yojson.Safe.json Deferred.Or_error.t
    val delete : t -> Yojson.Safe.json Deferred.Or_error.t
    val disallow_mention : t -> Yojson.Safe.json Deferred.Or_error.t
    val hoist : t -> Yojson.Safe.json Deferred.Or_error.t
    val set_colour : colour:int -> t -> Yojson.Safe.json Deferred.Or_error.t
    val set_name : name:string -> t -> Yojson.Safe.json Deferred.Or_error.t
    val unhoist : t -> Yojson.Safe.json Deferred.Or_error.t
end

module type User = sig
    type t = User_t.t
    val tag : t -> string
    val mention : t -> string
    val default_avatar : t -> string
    val face : t -> string
    (* val private_channel : t -> Channel_t.t *)
    (* val send : t -> Yojson.Safe.json Deferred.Or_error.t *)
end

module type Guild = sig
    type t = Guild_t.t
    val ban_user : id:Snowflake.t -> ?reason:string -> ?days:int -> t -> unit Deferred.Or_error.t
    val create_emoji : name:string -> image:string -> t -> Emoji.t Deferred.Or_error.t
    val create_role :
        name:string ->
        ?colour:int ->
        ?permissions:int ->
        ?hoist:bool ->
        ?mentionable:bool ->
        t ->
        Role_t.t Deferred.Or_error.t
    val create_channel : mode:[ `Text | `Voice | `Category ] -> name:string -> t -> Channel_t.t Deferred.Or_error.t
    val delete : t -> unit Deferred.Or_error.t
    val get_ban : id:Snowflake.t -> t -> Ban_t.t Deferred.Or_error.t
    val get_bans : t -> Ban_t.t list Deferred.Or_error.t
    val get_channel : id:Snowflake.t -> t -> Channel_t.t Deferred.Or_error.t
    val get_emoji : id:Snowflake.t -> t -> Emoji.t Deferred.Or_error.t
    val get_invites : t -> Yojson.Safe.json Deferred.Or_error.t
    val get_member : id:Snowflake.t -> t -> Member_t.t Deferred.Or_error.t
    val get_prune_count : days:int -> t -> int Deferred.Or_error.t
    val get_role : id:Snowflake.t -> t -> Role_t.t option
    val get_webhooks : t -> Yojson.Safe.json Deferred.Or_error.t
    val kick_user : id:Snowflake.t -> ?reason:string -> t -> unit Deferred.Or_error.t
    val leave : t -> Yojson.Safe.json Deferred.Or_error.t
    val list_voice_regions : t -> Yojson.Safe.json Deferred.Or_error.t
    val prune : days:int -> t -> int Deferred.Or_error.t
    val request_members : t -> Member_t.t list Deferred.Or_error.t
    val set_afk_channel : id:Snowflake.t -> t -> t Deferred.Or_error.t
    val set_afk_timeout : timeout:int -> t -> t Deferred.Or_error.t
    val set_name : name:string -> t -> t Deferred.Or_error.t
    val set_icon : icon:string -> t -> t Deferred.Or_error.t
    val unban_user : id:Snowflake.t -> ?reason:string -> t -> unit Deferred.Or_error.t
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
            Yojson.Safe.json Deferred.Or_error.t

        val request :
            ?body:Yojson.Safe.json ->
            [> `DELETE | `GET | `PATCH | `POST | `PUT ] ->
            string ->
            Yojson.Safe.json Deferred.Or_error.t
    end

    (* Auto-generated signatures *)
    val get_gateway : unit -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val get_gateway_bot : unit -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val get_channel : int -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val modify_channel :
      int -> Yojson.Safe.json -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val delete_channel : int -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val get_messages : int -> int -> string * int -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val get_message : int -> int -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val create_message :
      int -> Yojson.Safe.json -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val create_reaction :
      int -> int -> string -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val delete_own_reaction :
      int -> int -> string -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val delete_reaction :
      int -> int -> string -> int -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val get_reactions :
      int -> int -> string -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val delete_reactions :
      int -> int -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val edit_message :
      int ->
      int -> Yojson.Safe.json -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val delete_message :
      int -> int -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val bulk_delete :
      int -> Yojson.Safe.json -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val edit_channel_permissions :
      int ->
      int -> Yojson.Safe.json -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val get_channel_invites : int -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val create_channel_invite :
      int -> Yojson.Safe.json -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val delete_channel_permission :
      int -> int -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val broadcast_typing : int -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val get_pinned_messages : int -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val pin_message : int -> int -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val unpin_message : int -> int -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val group_recipient_add :
      int -> int -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val group_recipient_remove :
      int -> int -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val get_emojis : int -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val get_emoji : int -> int -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val create_emoji :
      int -> Yojson.Safe.json -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val edit_emoji :
      int ->
      int -> Yojson.Safe.json -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val delete_emoji : int -> int -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val create_guild :
      Yojson.Safe.json -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val get_guild : int -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val edit_guild :
      int -> Yojson.Safe.json -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val delete_guild : int -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val get_guild_channels : int -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val create_guild_channel :
      int -> Yojson.Safe.json -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val modify_guild_channel_positions :
      int -> Yojson.Safe.json -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val get_member : int -> int -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val get_members : int -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val add_member :
      int ->
      int -> Yojson.Safe.json -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val edit_member :
      int ->
      int -> Yojson.Safe.json -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val remove_member :
      int ->
      int -> Yojson.Safe.json -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val change_nickname :
      int -> Yojson.Safe.json -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val add_member_role :
      int -> int -> int -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val remove_member_role :
      int -> int -> int -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val get_bans : int -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val get_ban : int -> int -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val guild_ban_add :
      int ->
      int -> Yojson.Safe.json -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val guild_ban_remove :
      int ->
      int -> Yojson.Safe.json -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val get_roles : int -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val guild_role_add :
      int -> Yojson.Safe.json -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val guild_roles_edit :
      int -> Yojson.Safe.json -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val guild_role_edit :
      int ->
      int -> Yojson.Safe.json -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val guild_role_remove :
      int -> int -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val guild_prune_count :
      int -> int -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val guild_prune_start :
      int -> int -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val get_guild_voice_regions :
      int -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val get_guild_invites : int -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val get_integrations : int -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val add_integration :
      int -> Yojson.Safe.json -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val edit_integration :
      int ->
      int -> Yojson.Safe.json -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val delete_integration :
      int -> int -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val sync_integration :
      int -> int -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val get_guild_embed : int -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val edit_guild_embed :
      int -> Yojson.Safe.json -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val get_vanity_url : int -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val get_invite : string -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val delete_invite : string -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val get_current_user : unit -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val edit_current_user :
      Yojson.Safe.json -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val get_guilds : unit -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val leave_guild : int -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val get_private_channels :
      unit -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val create_dm :
      Yojson.Safe.json -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val create_group_dm :
      Yojson.Safe.json -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val get_connections : unit -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val get_user : int -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val get_voice_regions : unit -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val create_webhook :
      int -> Yojson.Safe.json -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val get_channel_webhooks : int -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val get_guild_webhooks : int -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val get_webhook : int -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val get_webhook_with_token :
      int -> string -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val edit_webhook :
      int -> Yojson.Safe.json -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val edit_webhook_with_token :
      int ->
      string -> Yojson.Safe.json -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val delete_webhook : int -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val delete_webhook_with_token :
      int -> string -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val execute_webhook :
      int ->
      string -> Yojson.Safe.json -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val execute_slack_webhook :
      int ->
      string -> Yojson.Safe.json -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val execute_git_webhook :
      int ->
      string -> Yojson.Safe.json -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
    val get_audit_logs :
      int -> Yojson.Safe.json -> Yojson.Safe.json Core.Or_error.t Conduit_async.io
end

module type Models = sig
    module Ban : Ban
    module Channel : Channel
    module Guild : Guild
    module Member : Member
    module Message : Message
    module Reaction : Reaction
    module Role : Role
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
    val dispatch : ev:string -> Yojson.Safe.json -> unit
end

module type Sharder = sig
    exception Invalid_Payload
    exception Failureo_Establish_Heartbeat

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
