(* Auto-generated from "attachment.atd" *)
              [@@@ocaml.warning "-27-32-35-39"]

type snowflake = Snowflake_t.t

type t = {
  id: snowflake;
  filename: string;
  size: int;
  url: string;
  proxy_url: string;
  height: int option;
  width: int option
}
