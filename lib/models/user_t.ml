(* Auto-generated from "user.atd" *)
              [@@@ocaml.warning "-27-32-35-39"]

type snowflake = Snowflake_t.t

type t = {
  id: snowflake;
  username: string;
  discriminator: string;
  avatar: string option;
  bot: bool
}
