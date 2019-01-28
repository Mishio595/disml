type unavailable = {
    id: Guild_id_t.t;
} [@@deriving sexp, yojson]

(** Used internally. *)
type pre = {
    id: Guild_id_t.t;
    name: string;
    icon: string option;
    splash: string option;
    owner_id: User_id_t.t;
    region: string;
    afk_channel_id: Channel_id_t.t option;
    afk_timeout: int;
    embed_enabled: bool;
    embed_channel_id: Channel_id_t.t option;
    verification_level: int;
    default_message_notifications: int;
    explicit_content_filter: int;
    roles: Role_t.role list;
    emojis: Emoji.t list;
    features: string list;
    mfa_level: int;
    application_id: Snowflake.t option;
    widget_enabled: bool;
    widget_channel_id: Channel_id_t.t option;
    system_channel_id: Channel_id_t.t option;
    large: bool;
    unavailable: bool;
    member_count: int option;
    members: Member_t.member list;
    channels: Channel_t.channel_wrapper list;
} [@@deriving sexp, yojson]

(** A Guild object *)
type t = {
    id: Guild_id_t.t; (** The guild's snowflake ID. *)
    name: string; (** The guild name. *)
    icon: string option; (** The guild icon hash, if one is set. *)
    splash: string option; (** The guild splash hash, if one is set. *)
    owner_id: User_id_t.t; (** The user ID of the owner. *)
    region: string; (** The region the guild is in. *)
    afk_channel_id: Channel_id_t.t option; (** The AFK channel ID, if one is set. *)
    afk_timeout: int; (** The time before a user is moved to the AFK channel. *)
    embed_enabled: bool; (** Whether the embed is enabled. *)
    embed_channel_id: Channel_id_t.t option; (** The channel ID of the embed channel, if it is enabled. *)
    verification_level: int; (** See {{:https://discordapp.com/developers/docs/resources/guild#guild-object-verification-level} the discord docs} for details. *)
    default_message_notifications: int; (** 0 = All messages, 1 = Only mentions *)
    explicit_content_filter: int; (** 0 = Disabled, 1 = For members with no roles, 2 = All members *)
    roles: Role_t.t list; (** List of roles in the guild. *)
    emojis: Emoji.t list; (** List of custom emojis in the guild. *)
    features: string list; (** A List of features enabled for the guild. *)
    mfa_level: int; (** 0 = None, 1 = Elevated *)
    application_id: Snowflake.t option; (** Snowflake ID if the guild is bot-created. *)
    widget_enabled: bool; (** Whether the widget is enabled. *)
    widget_channel_id: Channel_id_t.t option; (** The channel ID for the widget, if enabled. *)
    system_channel_id: Channel_id_t.t option; (** The channel ID where system messages are sent. *)
    large: bool; (** Whether the guild exceeds the configured large threshold. *)
    unavailable: bool; (** Whether the guild is unavailable or not. *)
    member_count: int option; (** Total number of members in the guild. *)
    members: Member_t.t list; (** List of guild members. *)
    channels: Channel_t.t list; (** List of guild channels. *)
} [@@deriving sexp, yojson]

val wrap : pre -> t
val get_id : t -> Snowflake.t