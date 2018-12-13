(* Auto-generated from "member.atd" *)
              [@@@ocaml.warning "-27-32-35-39"]

type user = User_t.t

type snowflake = Snowflake_t.t

type t = {
  user: user;
  nick: string option;
  roles: snowflake list;
  joined_at: string;
  deaf: bool;
  mute: bool
}
