open Async

type t = {
    hello: Yojson.Basic.json Pipe.Reader.t * Yojson.Basic.json Pipe.Writer.t;
    ready: Yojson.Basic.json Pipe.Reader.t * Yojson.Basic.json Pipe.Writer.t;
    resumed: Yojson.Basic.json Pipe.Reader.t * Yojson.Basic.json Pipe.Writer.t;
    invalid_session: Yojson.Basic.json Pipe.Reader.t * Yojson.Basic.json Pipe.Writer.t;
    channel_create: Channel.t Pipe.Reader.t * Channel.t Pipe.Writer.t;
    channel_update: Channel.t Pipe.Reader.t * Channel.t Pipe.Writer.t;
    channel_delete: Channel.t Pipe.Reader.t * Channel.t Pipe.Writer.t;
    channel_pins_update: Yojson.Basic.json Pipe.Reader.t * Yojson.Basic.json Pipe.Writer.t;
    guild_create: Guild.t Pipe.Reader.t * Guild.t Pipe.Writer.t;
    guild_update: Guild.t Pipe.Reader.t * Guild.t Pipe.Writer.t;
    guild_delete: Guild.t Pipe.Reader.t * Guild.t Pipe.Writer.t;
    guild_ban_add: Ban.t Pipe.Reader.t * Ban.t Pipe.Writer.t;
    guild_ban_remove: Ban.t Pipe.Reader.t * Ban.t Pipe.Writer.t;
    guild_emojis_update: Yojson.Basic.json Pipe.Reader.t * Yojson.Basic.json Pipe.Writer.t;
    guild_integrations_update: Yojson.Basic.json Pipe.Reader.t * Yojson.Basic.json Pipe.Writer.t;
    guild_member_add: Member.t Pipe.Reader.t * Member.t Pipe.Writer.t;
    guild_member_remove: Member.t Pipe.Reader.t * Member.t Pipe.Writer.t;
    guild_member_update: Member.t Pipe.Reader.t * Member.t Pipe.Writer.t;
    guild_members_chunk: (Member.t list) Pipe.Reader.t * (Member.t list) Pipe.Writer.t;
    guild_role_create: (Role.t * Guild.t) Pipe.Reader.t * (Role.t * Guild.t) Pipe.Writer.t;
    guild_role_update: (Role.t * Guild.t) Pipe.Reader.t * (Role.t * Guild.t) Pipe.Writer.t;
    guild_role_delete: (Role.t * Guild.t) Pipe.Reader.t * (Role.t * Guild.t) Pipe.Writer.t;
    message_create: Message.t Pipe.Reader.t * Message.t Pipe.Writer.t;
    message_update: Message.t Pipe.Reader.t * Message.t Pipe.Writer.t;
    message_delete: Message.t Pipe.Reader.t * Message.t Pipe.Writer.t;
    message_bulk_delete: (Message.t list) Pipe.Reader.t * (Message.t list) Pipe.Writer.t;
    message_reaction_add: (Message.t * Reaction.t) Pipe.Reader.t * (Message.t * Reaction.t) Pipe.Writer.t;
    message_reaction_remove: (Message.t * Reaction.t) Pipe.Reader.t * (Message.t * Reaction.t) Pipe.Writer.t;
    message_reaction_remove_all: (Message.t * Reaction.t) Pipe.Reader.t * (Message.t * Reaction.t) Pipe.Writer.t;
    presence_update: Presence.t Pipe.Reader.t * Presence.t Pipe.Writer.t;
    typing_start: Yojson.Basic.json Pipe.Reader.t * Yojson.Basic.json Pipe.Writer.t;
    user_update: Yojson.Basic.json Pipe.Reader.t * Yojson.Basic.json Pipe.Writer.t;
    voice_state_update: Yojson.Basic.json Pipe.Reader.t * Yojson.Basic.json Pipe.Writer.t;
    voice_server_update: Yojson.Basic.json Pipe.Reader.t * Yojson.Basic.json Pipe.Writer.t;
    webhooks_update: Yojson.Basic.json Pipe.Reader.t * Yojson.Basic.json Pipe.Writer.t;
}

let dispatcher =
    {
        hello = Pipe.create ();
        ready = Pipe.create ();
        resumed = Pipe.create ();
        invalid_session = Pipe.create ();
        channel_create = Pipe.create ();
        channel_update = Pipe.create ();
        channel_delete = Pipe.create ();
        channel_pins_update = Pipe.create ();
        guild_create = Pipe.create ();
        guild_update = Pipe.create ();
        guild_delete = Pipe.create ();
        guild_ban_add = Pipe.create ();
        guild_ban_remove = Pipe.create ();
        guild_emojis_update = Pipe.create ();
        guild_integrations_update = Pipe.create ();
        guild_member_add = Pipe.create ();
        guild_member_remove = Pipe.create ();
        guild_member_update = Pipe.create ();
        guild_members_chunk = Pipe.create ();
        guild_role_create = Pipe.create ();
        guild_role_update = Pipe.create ();
        guild_role_delete = Pipe.create ();
        message_create = Pipe.create ();
        message_update = Pipe.create ();
        message_delete = Pipe.create ();
        message_bulk_delete = Pipe.create ();
        message_reaction_add = Pipe.create ();
        message_reaction_remove = Pipe.create ();
        message_reaction_remove_all = Pipe.create ();
        presence_update = Pipe.create ();
        typing_start = Pipe.create ();
        user_update = Pipe.create ();
        voice_state_update = Pipe.create ();
        voice_server_update = Pipe.create ();
        webhooks_update = Pipe.create ();
    }

(* let write (ev:Event.t) =
    let (read, _) = match ev with
    | HELLO -> dispatcher.hello
    | READY -> dispatcher.ready
    | RESUMED -> dispatcher.resumed
    | INVALID_SESSION -> dispatcher.invalid_session
    | CHANNEL_CREATE -> dispatcher.channel_create
    | CHANNEL_UPDATE -> dispatcher.channel_update
    | CHANNEL_DELETE -> dispatcher.channel_delete
    | CHANNEL_PINS_UPDATE -> dispatcher.channel_pins_update
    | GUILD_CREATE -> dispatcher.guild_create
    | GUILD_UPDATE -> dispatcher.guild_update
    | GUILD_DELETE -> dispatcher.guild_delete
    | GUILD_BAN_ADD -> dispatcher.guild_ban_add
    | GUILD_BAN_REMOVE -> dispatcher.guild_ban_remove
    | GUILD_EMOJIS_UPDATE -> dispatcher.guild_emojis_update
    | GUILD_INTEGRATIONS_UPDATE -> dispatcher.guild_integrations_update
    | GUILD_MEMBER_ADD -> dispatcher.guild_member_ad
    | GUILD_MEMBER_REMOVE -> dispatcher.guild_member_remove
    | GUILD_MEMBER_UPDATE -> dispatcher.guild_member_update
    | GUILD_MEMBERS_CHUNK -> dispatcher.guild_members_chunk
    | GUILD_ROLE_CREATE -> dispatcher.guild_role_create
    | GUILD_ROLE_UPDATE -> dispatcher.guild_role_updatE
    | GUILD_ROLE_DELETE -> dispatcher.guild_role_delete
    | MESSAGE_CREATE -> dispatcher.message_create
    | MESSAGE_UPDATE -> dispatcher.message_update
    | MESSAGE_DELETE -> dispatcher.message_delete
    | MESSAGE_BULK_DELETE -> dispatcher.message_bulk_delete
    | MESSAGE_REACTION_ADD -> dispatcher.message_reaction_add
    | MESSAGE_REACTION_REMOVE -> dispatcher.message_reaction_remove
    | MESSAGE_REACTION_REMOVE_ALL -> dispatcher.message_reaction_remove_all
    | PRESENCE_UPDATE -> dispatcher.presence_update
    | TYPING_START -> dispatcher.typing_start
    | USER_UPDATE -> dispatcher.user_update
    | VOICE_STATE_UPDATE -> dispatcher.voice_state_update
    | VOICE_SERVER_UPDATE -> dispatcher.voice_server_update
    | WEBHOOKS_UPDATE -> dispatcher.webhooks_update *)