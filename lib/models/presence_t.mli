(* Auto-generated from "presence.atd" *)
              [@@@ocaml.warning "-27-32-35-39"]

type user = User_t.t

type snowflake = Snowflake_t.t

type partial_user = User_t.partial_user

type activity = Activity_t.t

type t = {
  user: partial_user;
  roles: snowflake list;
  game: activity option;
  guild_id: snowflake;
  status: string;
  activities: activity list
}
