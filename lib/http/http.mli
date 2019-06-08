module Base : sig
    exception Invalid_Method

    val base_url : string

    val process_url : string -> Uri.t
    val process_request_body : Yojson.Safe.t -> Cohttp_lwt.Body.t
    val process_request_headers : unit -> Cohttp.Header.t

    val process_response :
        string ->
        Cohttp_lwt.Response.t * Cohttp_lwt.Body.t ->
        (Yojson.Safe.t, string) Lwt_result.t

    val request :
        ?body:Yojson.Safe.t ->
        ?query:(string * string) list ->
        [ `Delete | `Get | `Patch | `Post | `Put ] ->
        Endpoints.t ->
        (Yojson.Safe.t, string) Lwt_result.t
end

val get_gateway : unit -> (Yojson.Safe.t, string) Lwt_result.t
val get_gateway_bot : unit -> (Yojson.Safe.t, string) Lwt_result.t
val get_channel : int -> (Channel_t.t, string) Lwt_result.t
val modify_channel :
    int -> Yojson.Safe.t -> (Channel_t.t, string) Lwt_result.t
val delete_channel : int -> (Channel_t.t, string) Lwt_result.t
val get_messages : int -> int -> string * int -> (Message_t.t list, string) Lwt_result.t
val get_message : int -> int -> (Message_t.t, string) Lwt_result.t
val create_message :
    int -> Yojson.Safe.t -> (Message_t.t, string) Lwt_result.t
val create_reaction :
    int -> int -> string -> (unit, string) Lwt_result.t
val delete_own_reaction :
    int -> int -> string -> (unit, string) Lwt_result.t
val delete_reaction :
    int -> int -> string -> int -> (unit, string) Lwt_result.t
val get_reactions :
    int -> int -> string -> (User_t.t list, string) Lwt_result.t
val delete_reactions :
    int -> int -> (unit, string) Lwt_result.t
val edit_message :
    int ->
    int -> Yojson.Safe.t -> (Message_t.t, string) Lwt_result.t
val delete_message :
    int -> int -> (unit, string) Lwt_result.t
val bulk_delete :
    int -> Yojson.Safe.t -> (unit, string) Lwt_result.t
val edit_channel_permissions :
    int ->
    int -> Yojson.Safe.t -> (unit, string) Lwt_result.t
val get_channel_invites : int -> (Yojson.Safe.t, string) Lwt_result.t
val create_channel_invite :
    int -> Yojson.Safe.t -> (Yojson.Safe.t, string) Lwt_result.t
val delete_channel_permission :
    int -> int -> (unit, string) Lwt_result.t
val broadcast_typing : int -> (unit, string) Lwt_result.t
val get_pinned_messages : int -> (Message_t.t list, string) Lwt_result.t
val pin_message : int -> int -> (unit, string) Lwt_result.t
val unpin_message : int -> int -> (unit, string) Lwt_result.t
val group_recipient_add :
    int -> int -> (unit, string) Lwt_result.t
val group_recipient_remove :
    int -> int -> (unit, string) Lwt_result.t
val get_emojis : int -> (Emoji.t list, string) Lwt_result.t
val get_emoji : int -> int -> (Emoji.t, string) Lwt_result.t
val create_emoji :
    int -> Yojson.Safe.t -> (Emoji.t, string) Lwt_result.t
val edit_emoji :
    int ->
    int -> Yojson.Safe.t -> (Emoji.t, string) Lwt_result.t
val delete_emoji : int -> int -> (unit, string) Lwt_result.t
val create_guild :
    Yojson.Safe.t -> (Guild_t.t, string) Lwt_result.t
val get_guild : int -> (Guild_t.t, string) Lwt_result.t
val edit_guild :
    int -> Yojson.Safe.t -> (Guild_t.t, string) Lwt_result.t
val delete_guild : int -> (unit, string) Lwt_result.t
val get_guild_channels : int -> (Channel_t.t list, string) Lwt_result.t
val create_guild_channel :
    int -> Yojson.Safe.t -> (Channel_t.t, string) Lwt_result.t
val modify_guild_channel_positions :
    int -> Yojson.Safe.t -> (unit, string) Lwt_result.t
val get_member : int -> int -> (Member.t, string) Lwt_result.t
val get_members : int -> (Member.t list, string) Lwt_result.t
val add_member :
    int ->
    int -> Yojson.Safe.t -> (Member.t, string) Lwt_result.t
val edit_member :
    int ->
    int -> Yojson.Safe.t -> (unit, string) Lwt_result.t
val remove_member :
    int ->
    int -> Yojson.Safe.t -> (unit, string) Lwt_result.t
val change_nickname :
    int -> Yojson.Safe.t -> (Yojson.Safe.t, string) Lwt_result.t
val add_member_role :
    int -> int -> int -> (unit, string) Lwt_result.t
val remove_member_role :
    int -> int -> int -> (unit, string) Lwt_result.t
val get_bans : int -> (Ban.t list, string) Lwt_result.t
val get_ban : int -> int -> (Ban.t, string) Lwt_result.t
val guild_ban_add :
    int ->
    int -> Yojson.Safe.t -> (unit, string) Lwt_result.t
val guild_ban_remove :
    int ->
    int -> Yojson.Safe.t -> (unit, string) Lwt_result.t
val get_roles : int -> (Role_t.t list, string) Lwt_result.t
val guild_role_add :
    int -> Yojson.Safe.t -> (Role_t.t, string) Lwt_result.t
val guild_roles_edit :
    int -> Yojson.Safe.t -> (Role_t.t list, string) Lwt_result.t
val guild_role_edit :
    int ->
    int -> Yojson.Safe.t -> (Role_t.t, string) Lwt_result.t
val guild_role_remove :
    int -> int -> (unit, string) Lwt_result.t
val guild_prune_count :
    int -> int -> (int, string) Lwt_result.t
val guild_prune_start :
    int -> int -> (int, string) Lwt_result.t
val get_guild_voice_regions :
    int -> (Yojson.Safe.t, string) Lwt_result.t
val get_guild_invites : int -> (Yojson.Safe.t, string) Lwt_result.t
val get_integrations : int -> (Yojson.Safe.t, string) Lwt_result.t
val add_integration :
    int -> Yojson.Safe.t -> (unit, string) Lwt_result.t
val edit_integration :
    int ->
    int -> Yojson.Safe.t -> (unit, string) Lwt_result.t
val delete_integration :
    int -> int -> (unit, string) Lwt_result.t
val sync_integration :
    int -> int -> (unit, string) Lwt_result.t
val get_guild_embed : int -> (Yojson.Safe.t, string) Lwt_result.t
val edit_guild_embed :
    int -> Yojson.Safe.t -> (Yojson.Safe.t, string) Lwt_result.t
val get_vanity_url : int -> (Yojson.Safe.t, string) Lwt_result.t
val get_invite : string -> (Yojson.Safe.t, string) Lwt_result.t
val delete_invite : string -> (Yojson.Safe.t, string) Lwt_result.t
val get_current_user : unit -> (User_t.t, string) Lwt_result.t
val edit_current_user :
    Yojson.Safe.t -> (User_t.t, string) Lwt_result.t
val get_guilds : unit -> (Guild_t.t list, string) Lwt_result.t
val leave_guild : int -> (unit, string) Lwt_result.t
val get_private_channels :
    unit -> (Yojson.Safe.t, string) Lwt_result.t
val create_dm :
    Yojson.Safe.t -> (Yojson.Safe.t, string) Lwt_result.t
val create_group_dm :
    Yojson.Safe.t -> (Yojson.Safe.t, string) Lwt_result.t
val get_connections : unit -> (Yojson.Safe.t, string) Lwt_result.t
val get_user : int -> (User_t.t, string) Lwt_result.t
val get_voice_regions : unit -> (Yojson.Safe.t, string) Lwt_result.t
val create_webhook :
    int -> Yojson.Safe.t -> (Yojson.Safe.t, string) Lwt_result.t
val get_channel_webhooks : int -> (Yojson.Safe.t, string) Lwt_result.t
val get_guild_webhooks : int -> (Yojson.Safe.t, string) Lwt_result.t
val get_webhook : int -> (Yojson.Safe.t, string) Lwt_result.t
val get_webhook_with_token :
    int -> string -> (Yojson.Safe.t, string) Lwt_result.t
val edit_webhook :
    int -> Yojson.Safe.t -> (Yojson.Safe.t, string) Lwt_result.t
val edit_webhook_with_token :
    int ->
    string -> Yojson.Safe.t -> (Yojson.Safe.t, string) Lwt_result.t
val delete_webhook : int -> (unit, string) Lwt_result.t
val delete_webhook_with_token :
    int -> string -> (unit, string) Lwt_result.t
val execute_webhook :
    int ->
    string -> Yojson.Safe.t -> (Yojson.Safe.t, string) Lwt_result.t
val execute_slack_webhook :
    int ->
    string -> Yojson.Safe.t -> (Yojson.Safe.t, string) Lwt_result.t
val execute_git_webhook :
    int ->
    string -> Yojson.Safe.t -> (Yojson.Safe.t, string) Lwt_result.t
val get_audit_logs :
    int -> Yojson.Safe.t -> (Yojson.Safe.t, string) Lwt_result.t
val get_application_info : unit -> (Yojson.Safe.t, string) Lwt_result.t