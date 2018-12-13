(* Auto-generated from "presence.atd" *)
              [@@@ocaml.warning "-27-32-35-39"]

type user = User_t.t

type role = Role_t.t

type guild = Guild_t.t

type activity = Activity_t.t

type t = {
  user: user;
  roles: role list;
  game: activity option;
  guild: guild;
  status: string;
  activities: activity list
}
