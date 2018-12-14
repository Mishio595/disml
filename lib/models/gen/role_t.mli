(* Auto-generated from "role.atd" *)
              [@@@ocaml.warning "-27-32-35-39"]

type snowflake = Snowflake_t.t

type t = {
  id: snowflake;
  name: string;
  colour: int;
  hoist: bool;
  position: int;
  permissions: int;
  managed: bool;
  mentionable: bool
}
