(* Auto-generated from "guild.atd" *)
              [@@@ocaml.warning "-27-32-35-39"]

type user = User_t.t

type snowflake = Snowflake_t.t

type role = Role_t.t

type member = Member_t.t

type emoji = Emoji_t.t

type channel = Channel_t.t

type t = {
  id: snowflake;
  name: string;
  icon: string option;
  splash: string option;
  owner_id: snowflake;
  region: string;
  afk_channel_id: snowflake option;
  afk_timeout: int;
  embed_enabled: bool option;
  embed_channel_id: snowflake option;
  verification_level: int;
  default_message_notifications: int;
  explicit_content_filter: int;
  roles: role list;
  emojis: emoji list;
  features: string list;
  mfa_level: int;
  application_id: snowflake option;
  widget_enabled: bool option;
  widget_channel: channel option;
  system_channel: channel option;
  large: bool option;
  unavailable: bool option;
  member_count: int option;
  members: member list;
  channels: channel list
}
