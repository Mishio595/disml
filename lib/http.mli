open Async

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
        ?query:(string * string) list ->
        [> `DELETE | `GET | `PATCH | `POST | `PUT ] ->
        string ->
        Yojson.Safe.json Deferred.Or_error.t
end

(* Auto-generated signatures *)
val get_gateway : unit -> Yojson.Safe.json Deferred.Or_error.t
val get_gateway_bot : unit -> Yojson.Safe.json Deferred.Or_error.t
val get_channel : int -> Yojson.Safe.json Deferred.Or_error.t
val modify_channel :
    int -> Yojson.Safe.json -> Yojson.Safe.json Deferred.Or_error.t
val delete_channel : int -> Yojson.Safe.json Deferred.Or_error.t
val get_messages : int -> int -> string * int -> Yojson.Safe.json Deferred.Or_error.t
val get_message : int -> int -> Yojson.Safe.json Deferred.Or_error.t
val create_message :
    int -> Yojson.Safe.json -> Yojson.Safe.json Deferred.Or_error.t
val create_reaction :
    int -> int -> string -> Yojson.Safe.json Deferred.Or_error.t
val delete_own_reaction :
    int -> int -> string -> Yojson.Safe.json Deferred.Or_error.t
val delete_reaction :
    int -> int -> string -> int -> Yojson.Safe.json Deferred.Or_error.t
val get_reactions :
    int -> int -> string -> Yojson.Safe.json Deferred.Or_error.t
val delete_reactions :
    int -> int -> Yojson.Safe.json Deferred.Or_error.t
val edit_message :
    int ->
    int -> Yojson.Safe.json -> Yojson.Safe.json Deferred.Or_error.t
val delete_message :
    int -> int -> Yojson.Safe.json Deferred.Or_error.t
val bulk_delete :
    int -> Yojson.Safe.json -> Yojson.Safe.json Deferred.Or_error.t
val edit_channel_permissions :
    int ->
    int -> Yojson.Safe.json -> Yojson.Safe.json Deferred.Or_error.t
val get_channel_invites : int -> Yojson.Safe.json Deferred.Or_error.t
val create_channel_invite :
    int -> Yojson.Safe.json -> Yojson.Safe.json Deferred.Or_error.t
val delete_channel_permission :
    int -> int -> Yojson.Safe.json Deferred.Or_error.t
val broadcast_typing : int -> Yojson.Safe.json Deferred.Or_error.t
val get_pinned_messages : int -> Yojson.Safe.json Deferred.Or_error.t
val pin_message : int -> int -> Yojson.Safe.json Deferred.Or_error.t
val unpin_message : int -> int -> Yojson.Safe.json Deferred.Or_error.t
val group_recipient_add :
    int -> int -> Yojson.Safe.json Deferred.Or_error.t
val group_recipient_remove :
    int -> int -> Yojson.Safe.json Deferred.Or_error.t
val get_emojis : int -> Yojson.Safe.json Deferred.Or_error.t
val get_emoji : int -> int -> Yojson.Safe.json Deferred.Or_error.t
val create_emoji :
    int -> Yojson.Safe.json -> Yojson.Safe.json Deferred.Or_error.t
val edit_emoji :
    int ->
    int -> Yojson.Safe.json -> Yojson.Safe.json Deferred.Or_error.t
val delete_emoji : int -> int -> Yojson.Safe.json Deferred.Or_error.t
val create_guild :
    Yojson.Safe.json -> Yojson.Safe.json Deferred.Or_error.t
val get_guild : int -> Yojson.Safe.json Deferred.Or_error.t
val edit_guild :
    int -> Yojson.Safe.json -> Yojson.Safe.json Deferred.Or_error.t
val delete_guild : int -> Yojson.Safe.json Deferred.Or_error.t
val get_guild_channels : int -> Yojson.Safe.json Deferred.Or_error.t
val create_guild_channel :
    int -> Yojson.Safe.json -> Yojson.Safe.json Deferred.Or_error.t
val modify_guild_channel_positions :
    int -> Yojson.Safe.json -> Yojson.Safe.json Deferred.Or_error.t
val get_member : int -> int -> Yojson.Safe.json Deferred.Or_error.t
val get_members : int -> Yojson.Safe.json Deferred.Or_error.t
val add_member :
    int ->
    int -> Yojson.Safe.json -> Yojson.Safe.json Deferred.Or_error.t
val edit_member :
    int ->
    int -> Yojson.Safe.json -> Yojson.Safe.json Deferred.Or_error.t
val remove_member :
    int ->
    int -> Yojson.Safe.json -> Yojson.Safe.json Deferred.Or_error.t
val change_nickname :
    int -> Yojson.Safe.json -> Yojson.Safe.json Deferred.Or_error.t
val add_member_role :
    int -> int -> int -> Yojson.Safe.json Deferred.Or_error.t
val remove_member_role :
    int -> int -> int -> Yojson.Safe.json Deferred.Or_error.t
val get_bans : int -> Yojson.Safe.json Deferred.Or_error.t
val get_ban : int -> int -> Yojson.Safe.json Deferred.Or_error.t
val guild_ban_add :
    int ->
    int -> Yojson.Safe.json -> Yojson.Safe.json Deferred.Or_error.t
val guild_ban_remove :
    int ->
    int -> Yojson.Safe.json -> Yojson.Safe.json Deferred.Or_error.t
val get_roles : int -> Yojson.Safe.json Deferred.Or_error.t
val guild_role_add :
    int -> Yojson.Safe.json -> Yojson.Safe.json Deferred.Or_error.t
val guild_roles_edit :
    int -> Yojson.Safe.json -> Yojson.Safe.json Deferred.Or_error.t
val guild_role_edit :
    int ->
    int -> Yojson.Safe.json -> Yojson.Safe.json Deferred.Or_error.t
val guild_role_remove :
    int -> int -> Yojson.Safe.json Deferred.Or_error.t
val guild_prune_count :
    int -> int -> Yojson.Safe.json Deferred.Or_error.t
val guild_prune_start :
    int -> int -> Yojson.Safe.json Deferred.Or_error.t
val get_guild_voice_regions :
    int -> Yojson.Safe.json Deferred.Or_error.t
val get_guild_invites : int -> Yojson.Safe.json Deferred.Or_error.t
val get_integrations : int -> Yojson.Safe.json Deferred.Or_error.t
val add_integration :
    int -> Yojson.Safe.json -> Yojson.Safe.json Deferred.Or_error.t
val edit_integration :
    int ->
    int -> Yojson.Safe.json -> Yojson.Safe.json Deferred.Or_error.t
val delete_integration :
    int -> int -> Yojson.Safe.json Deferred.Or_error.t
val sync_integration :
    int -> int -> Yojson.Safe.json Deferred.Or_error.t
val get_guild_embed : int -> Yojson.Safe.json Deferred.Or_error.t
val edit_guild_embed :
    int -> Yojson.Safe.json -> Yojson.Safe.json Deferred.Or_error.t
val get_vanity_url : int -> Yojson.Safe.json Deferred.Or_error.t
val get_invite : string -> Yojson.Safe.json Deferred.Or_error.t
val delete_invite : string -> Yojson.Safe.json Deferred.Or_error.t
val get_current_user : unit -> Yojson.Safe.json Deferred.Or_error.t
val edit_current_user :
    Yojson.Safe.json -> Yojson.Safe.json Deferred.Or_error.t
val get_guilds : unit -> Yojson.Safe.json Deferred.Or_error.t
val leave_guild : int -> Yojson.Safe.json Deferred.Or_error.t
val get_private_channels :
    unit -> Yojson.Safe.json Deferred.Or_error.t
val create_dm :
    Yojson.Safe.json -> Yojson.Safe.json Deferred.Or_error.t
val create_group_dm :
    Yojson.Safe.json -> Yojson.Safe.json Deferred.Or_error.t
val get_connections : unit -> Yojson.Safe.json Deferred.Or_error.t
val get_user : int -> Yojson.Safe.json Deferred.Or_error.t
val get_voice_regions : unit -> Yojson.Safe.json Deferred.Or_error.t
val create_webhook :
    int -> Yojson.Safe.json -> Yojson.Safe.json Deferred.Or_error.t
val get_channel_webhooks : int -> Yojson.Safe.json Deferred.Or_error.t
val get_guild_webhooks : int -> Yojson.Safe.json Deferred.Or_error.t
val get_webhook : int -> Yojson.Safe.json Deferred.Or_error.t
val get_webhook_with_token :
    int -> string -> Yojson.Safe.json Deferred.Or_error.t
val edit_webhook :
    int -> Yojson.Safe.json -> Yojson.Safe.json Deferred.Or_error.t
val edit_webhook_with_token :
    int ->
    string -> Yojson.Safe.json -> Yojson.Safe.json Deferred.Or_error.t
val delete_webhook : int -> Yojson.Safe.json Deferred.Or_error.t
val delete_webhook_with_token :
    int -> string -> Yojson.Safe.json Deferred.Or_error.t
val execute_webhook :
    int ->
    string -> Yojson.Safe.json -> Yojson.Safe.json Deferred.Or_error.t
val execute_slack_webhook :
    int ->
    string -> Yojson.Safe.json -> Yojson.Safe.json Deferred.Or_error.t
val execute_git_webhook :
    int ->
    string -> Yojson.Safe.json -> Yojson.Safe.json Deferred.Or_error.t
val get_audit_logs :
    int -> Yojson.Safe.json -> Yojson.Safe.json Deferred.Or_error.t