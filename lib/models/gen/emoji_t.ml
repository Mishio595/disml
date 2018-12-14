(* Auto-generated from "emoji.atd" *)
              [@@@ocaml.warning "-27-32-35-39"]

type user = User_t.t

type snowflake = Snowflake_t.t

type t = {
  id: snowflake option;
  name: string;
  roles: snowflake list option;
  user: user option;
  require_colons: bool option;
  managed: bool option;
  animated: bool option
}
