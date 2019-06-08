open Printf

type t =
{ endpoint: string
; route: string
}

let make endpoint = { endpoint; route = endpoint }
(* let make_complex endpoint route = { endpoint; route } *)

let gateway = make "/gateway"
let gateway_bot = make "/gateway/bot"

let channel cid =
    make (sprintf "/channels/%d" cid)
let channel_messages cid =
    make (sprintf "/channels/%d/messages" cid)
let channel_message cid mid =
    make (sprintf "/channels/%d/messages/%d" cid mid)
let channel_reaction_me cid mid em =
    make (sprintf "/channels/%d/messages/%d/reactions/%s/@me" cid mid em)
let channel_reaction cid mid em uid =
    make (sprintf "/channels/%d/messages/%d/reactions/%s/%d" cid mid em uid)
let channel_reactions_get cid mid em =
    make (sprintf "/channels/%d/messages/%d/reactions/%s" cid mid em)
let channel_reactions_delete cid mid =
    make (sprintf "/channels/%d/messages/%d/reactions" cid mid)
let channel_bulk_delete cid =
    make (sprintf "/channels/%d" cid)
let channel_permission cid uid =
    make (sprintf "/channels/%d/permissions/%d" cid uid)
let channel_permissions cid =
    make (sprintf "/channels/%d/permissions" cid)
let channels = make "/channels"
let channel_call_ring cid =
    make (sprintf "/channels/%d/call/ring" cid)
let channel_invites cid =
    make (sprintf "/channels/%d/invites" cid)
let channel_typing cid =
    make (sprintf "/channels/%d/typing" cid)
let channel_pins cid =
    make (sprintf "/channels/%d/pins" cid)
let channel_pin cid mid =
    make (sprintf "/channels/%d/pins/%d" cid mid)

let guilds = make "/guilds"
let guild gid =
    make (sprintf "/guilds/%d" gid)
let guild_channels gid =
    make (sprintf "/guilds/%d/channels" gid)
let guild_members gid =
    make (sprintf "/guilds/%d/members" gid)
let guild_member gid uid =
    make (sprintf "/guilds/%d/members/%d" gid uid)
let guild_member_role gid uid rid =
    make (sprintf "/guilds/%d/members/%d/roles/%d" gid uid rid)
let guild_bans gid =
    make (sprintf "/guilds/%d/bans" gid)
let guild_ban gid uid =
    make (sprintf "/guilds/%d/bans/%d" gid uid)
let guild_roles gid =
    make (sprintf "/guilds/%d/roles" gid)
let guild_role gid rid =
    make (sprintf "/guilds/%d/roles/%d" gid rid)
let guild_prune gid =
    make (sprintf "/guilds/%d/prune" gid)
let guild_voice_regions gid =
    make (sprintf "/guilds/%d/regions" gid)
let guild_invites gid =
    make (sprintf "/guilds/%d/invites" gid)
let guild_integrations gid =
    make (sprintf "/guilds/%d/integrations" gid)
let guild_integration gid iid =
    make (sprintf "/guilds/%d/integrations/%d" gid iid)
let guild_integration_sync gid iid =
    make (sprintf "/guilds/%d/integrations/%d/sync" gid iid)
let guild_embed gid =
    make (sprintf "/guilds/%d/embed" gid)
let guild_emojis gid =
    make (sprintf "/guilds/%d/emojis" gid)
let guild_emoji gid eid =
    make (sprintf "/guilds/%d/emojis/%d" gid eid)
let guild_me_nick gid =
    make (sprintf "/guilds/%d/members/@me/nick" gid)
let guild_vanity_url gid =
    make (sprintf "/guilds/%d/vanity-url" gid)
let guild_audit_logs gid =
    make (sprintf "/guilds/%d/audit-logs" gid)

let webhooks_guild gid =
    make (sprintf "/guilds/%d/webhooks" gid)
let webhooks_channel cid =
    make (sprintf "/channels/%d/webhooks" cid)
let webhook wid =
    make (sprintf "/webhooks/%d" wid)
let webhook_token wid token =
    make (sprintf "/webhooks/%d/%s" wid token)
let webhook_git wid token =
    make (sprintf "/webhooks/%d/%s/github" wid token)
let webhook_slack wid token =
    make (sprintf "/webhooks/%d/%s/slack" wid token)

let user uid =
    make (sprintf "/users/%d" uid)
let me = make "/users/@me"
let me_guilds = make "/users/@me/guilds"
let me_guild gid =
    make (sprintf "/users/@me/guilds/%d" gid)
let me_channels = make "/users/@me/channels"
let me_connections = make "/users/@me/connections"

let invite iid =
    make (sprintf "/invites/%s" iid)
let regions = make "/voice/regions"
let application_information = make "/oauth2/applications/@me"
let group_recipient cid uid =
    make (sprintf "/channels/%d/recipients/%d" cid uid)

let cdn_embed_avatar hash =
    make (sprintf "/embed/avatars/%s.png" hash)
let cdn_emoji hash ext =
    make (sprintf "/emojis/%s.%s" hash ext)
let cdn_icon uid hash ext =
    make (sprintf "/icons/%d/%s.%s" uid hash ext)
let cdn_avatar uid hash ext =
    make (sprintf "/avatars/%d/%s.%s" uid hash ext)
let cdn_default_avatar ind =
    make (sprintf "/embed/avatars/%d" ind)