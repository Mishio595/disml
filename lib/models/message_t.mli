(* Auto-generated from "message.atd" *)
              [@@@ocaml.warning "-27-32-35-39"]

type user = User_t.t

type snowflake = Snowflake_t.t

type role = Role_t.t

type reaction = Reaction_t.t

type member = Member_t.t

type embed = Embed_t.t

type attachment = Attachment_t.t

type t = {
  id: snowflake;
  author: user;
  channel_id: snowflake;
  member: member option;
  guild_id: snowflake option;
  content: string;
  timestamp: string;
  edited_timestamp: string option;
  tts: bool;
  mention_everyone: bool;
  mentions: user list;
  role_mentions: role list;
  attachments: attachment list;
  embeds: embed list;
  reactions: reaction list;
  nonce: snowflake option;
  pinned: bool;
  webhook_id: snowflake;
  kind: int
}
