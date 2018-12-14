(* Auto-generated from "message.atd" *)
              [@@@ocaml.warning "-27-32-35-39"]

type user = User_t.t

type snowflake = Snowflake_t.t

type partial_member = Member_t.partial_member

type embed = Embed_t.t

type attachment = Attachment_t.t

type t = {
  id: snowflake;
  author: user;
  channel_id: snowflake;
  member: partial_member option;
  guild_id: snowflake option;
  content: string;
  timestamp: string;
  edited_timestamp: string option;
  tts: bool;
  mention_everyone: bool;
  mentions: snowflake list;
  role_mentions: snowflake list option;
  attachments: attachment list;
  embeds: embed list;
  reactions: snowflake list option;
  nonce: snowflake option;
  pinned: bool;
  webhook_id: snowflake option;
  kind: int
}

type reaction = Reaction_t.t

type member = Member_t.t
