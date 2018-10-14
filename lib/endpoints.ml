let gateway = "/gateway"
let gateway_bot = "/gateway/bot"

let channel channel_id = "/channels/"^channel_id
let channel_messages channel_id = "/channels/"^channel_id^"/messages"

let channel_message channel_id msg_id =
    "/channels/"^channel_id^"/messages/"^msg_id

let channel_reaction_me channel_id msg_id emoji =
    "/channels/"^channel_id^"/messages/"^msg_id^"/reactions/"^emoji^"/@me"

let channel_reaction channel_id msg_id emoji user_id =
    "/channels/"^channel_id^"/messages/"^msg_id^"/reactions/"^emoji^"/"^user_id

let channel_reactions_get channel_id msg_id emoji =
    "/channels/"^channel_id^"/messages/"^msg_id^"/reactions/"^emoji

let channel_reactions_delete channel_id msg_id =
    "/channels/"^channel_id^"/messages/"^msg_id^"/reactions"

let channel_bulk_delete channel_id = "/channels/"^channel_id

let channel_permission channel_id overwrite_id =
    "/channels/"^channel_id^"/permissions/"^overwrite_id

let channel_permissions channel_id = "/channels"^channel_id^"/permissions"
let channels = "/channels"
let channel_call_ring channel_id = "/channels/"^channel_id^"/call/ring"
let channel_invites channel_id = "/channels/"^channel_id^"/invites"
let channel_typing channel_id = "/channels/"^channel_id^"/typing"
let channel_pins channel_id = "/channels/"^channel_id^"/pins"
let channel_pin channel_id msg_id = "/channels/"^channel_id^"/pins/"^msg_id

let guilds = "/guilds"
let guild guild_id = "/guilds/"^guild_id
let guild_channels guild_id = "/guilds/"^guild_id^"/channels"
let guild_members guild_id = "/guilds/"^guild_id^"/members"
let guild_member guild_id user_id = "/guilds/"^guild_id^"/members/"^user_id

let guild_member_role guild_id user_id role_id =
    "/guilds/"^guild_id^"/members/"^user_id^"/roles/"^role_id

let guild_bans guild_id = "/guilds/"^guild_id^"/bans"
let guild_ban guild_id user_id = "/guilds/"^guild_id^"/bans"^user_id
let guild_roles guild_id = "/guilds/"^guild_id^"/roles"
let guild_role guild_id role_id = "/guilds/"^guild_id^"/roles"^role_id
let guild_prune guild_id = "/guilds/"^guild_id^"/prune"
let guild_voice_regions guild_id = "/guilds/"^guild_id^"/regions"
let guild_invites guild_id = "/guilds/"^guild_id^"/invites"
let guild_integrations guild_id = "/guilds/"^guild_id^"/integrations"

let guild_integration guild_id integration_id =
    "/guilds/"^guild_id^"/integrations/"^integration_id

let guild_integration_sync guild_id integration_id =
    "/guilds/"^guild_id^"/integrations/"^integration_id^"/sync"

let guild_embed guild_id = "/guilds/"^guild_id^"/embed"
let guild_emojis guild_id = "/guilds/"^guild_id^"/emojis"
let guild_emoji guild_id emoji_id = "/guilds/"^guild_id^"/emojis/"^emoji_id

let webhooks_guild guild_id = "/guilds/"^guild_id^"/webhooks"
let webhooks_channel channel_id = "/channels/"^channel_id^"/webhooks"
let webhook webhook_id = "/webhooks/"^webhook_id
let webhook_token webhook_id token = "/webhooks/"^webhook_id^"/"^token

let webhook_git webhook_id token =
    "/webhooks/"^webhook_id^"/"^token^"/github"

let webhook_slack webhook_id token =
    "/webhooks/"^webhook_id^"/"^token^"/slack"

let user user_id = "/users/"^user_id

let me = "/users/@me"
let me_guilds = "/users/@me/guilds"
let me_guild guild_id = "/users/@me/guilds/"^guild_id
let me_channels = "/users/@me/channels"
let me_connections = "/users/@me/connections"

let invite code = "/invites/"^code
let regions = "/voice/regions"

let application_information = "/oauth2/applications/@me"

let group_recipient group_id user_id = "/channels/"^group_id^"/recipients/"^user_id
let guild_me_nick guild_id = "/guilds/"^guild_id^"/members/@me/nick"
let guild_vanity_url guild_id = "/guilds/"^guild_id^"/vanity-url"

(* let cdn_avatar id avatar image_format = "/avatars/"^id^"/"^avatar^"."^image_format *)
let cdn_embed_avatar image_name = "/embed/avatars/"^image_name^".png"
let cdn_emoji id image_format = "/emojis/"^id^"."^image_format
let cdn_icon id icon image_format = "/icons/"^id^"/"^icon^"."^image_format
let cdn_avatar id splash image_format = "/splashes/"^id^"/"^splash^"."^image_format