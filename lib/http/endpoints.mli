(** Endpoint formatters used internally. *)

val gateway : string
val gateway_bot : string
val channel : int -> string
val channel_messages : int -> string
val channel_message : int -> int -> string
val channel_reaction_me : int -> int -> string -> string
val channel_reaction : int -> int -> string -> int -> string
val channel_reactions_get : int -> int -> string -> string
val channel_reactions_delete : int -> int -> string
val channel_bulk_delete : int -> string
val channel_permission : int -> int -> string
val channel_permissions : int -> string
val channels : string
val channel_call_ring : int -> string
val channel_invites : int -> string
val channel_typing : int -> string
val channel_pins : int -> string
val channel_pin : int -> int -> string
val guilds : string
val guild : int -> string
val guild_channels : int -> string
val guild_members : int -> string
val guild_member : int -> int -> string
val guild_member_role : int -> int -> int -> string
val guild_bans : int -> string
val guild_ban : int -> int -> string
val guild_roles : int -> string
val guild_role : int -> int -> string
val guild_prune : int -> string
val guild_voice_regions : int -> string
val guild_invites : int -> string
val guild_integrations : int -> string
val guild_integration : int -> int -> string
val guild_integration_sync : int -> int -> string
val guild_embed : int -> string
val guild_emojis : int -> string
val guild_emoji : int -> int -> string
val webhooks_guild : int -> string
val webhooks_channel : int -> string
val webhook : int -> string
val webhook_token : int -> string -> string
val webhook_git : int -> string -> string
val webhook_slack : int -> string -> string
val user : int -> string
val me : string
val me_guilds : string
val me_guild : int -> string
val me_channels : string
val me_connections : string
val invite : string -> string
val regions : string
val application_information : string
val group_recipient : int -> int -> string
val guild_me_nick : int -> string
val guild_vanity_url : int -> string
val guild_audit_logs : int -> string
val cdn_embed_avatar : string -> string
val cdn_emoji : string -> string -> string
val cdn_icon : int -> string -> string -> string
val cdn_avatar : int -> string -> string -> string
val cdn_default_avatar : int -> string