(* Auto-generated from "channel.atd" *)
              [@@@ocaml.warning "-27-32-35-39"]

type user = User_t.t

type snowflake = Snowflake_t.t

type t = {
  id: snowflake;
  kind: int;
  guild_id: snowflake option;
  position: int option;
  name: string option;
  topic: string option;
  nsfw: bool option;
  bitrate: int option;
  user_limit: int option;
  recipients: user list option;
  icon: string option;
  owner_id: snowflake option;
  application_id: snowflake option;
  parent_id: snowflake option
}
