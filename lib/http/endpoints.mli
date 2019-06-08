(** Endpoint formatters used internally. *)

type t =
{ endpoint: string
; route: string
}

val gateway : t
val gateway_bot : t
val channel : int -> t
val channel_messages : int -> t
val channel_message : int -> int -> t
val channel_reaction_me : int -> int -> string -> t
val channel_reaction : int -> int -> string -> int -> t
val channel_reactions_get : int -> int -> string -> t
val channel_reactions_delete : int -> int -> t
val channel_bulk_delete : int -> t
val channel_permission : int -> int -> t
val channel_permissions : int -> t
val channels : t
val channel_call_ring : int -> t
val channel_invites : int -> t
val channel_typing : int -> t
val channel_pins : int -> t
val channel_pin : int -> int -> t
val guilds : t
val guild : int -> t
val guild_channels : int -> t
val guild_members : int -> t
val guild_member : int -> int -> t
val guild_member_role : int -> int -> int -> t
val guild_bans : int -> t
val guild_ban : int -> int -> t
val guild_roles : int -> t
val guild_role : int -> int -> t
val guild_prune : int -> t
val guild_voice_regions : int -> t
val guild_invites : int -> t
val guild_integrations : int -> t
val guild_integration : int -> int -> t
val guild_integration_sync : int -> int -> t
val guild_embed : int -> t
val guild_emojis : int -> t
val guild_emoji : int -> int -> t
val webhooks_guild : int -> t
val webhooks_channel : int -> t
val webhook : int -> t
val webhook_token : int -> string -> t
val webhook_git : int -> string -> t
val webhook_slack : int -> string -> t
val user : int -> t
val me : t
val me_guilds : t
val me_guild : int -> t
val me_channels : t
val me_connections : t
val invite : string -> t
val regions : t
val application_information : t
val group_recipient : int -> int -> t
val guild_me_nick : int -> t
val guild_vanity_url : int -> t
val guild_audit_logs : int -> t
val cdn_embed_avatar : string -> t
val cdn_emoji : string -> string -> t
val cdn_icon : int -> string -> string -> t
val cdn_avatar : int -> string -> string -> t
val cdn_default_avatar : int -> t