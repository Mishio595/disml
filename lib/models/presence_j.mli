(* Auto-generated from "presence.atd" *)
[@@@ocaml.warning "-27-32-35-39"]

type user = User_t.t

type role = Role_t.t

type guild = Guild_t.t

type activity = Activity_t.t

type t = Presence_t.t = {
  user: user;
  roles: role list;
  game: activity option;
  guild: guild;
  status: string;
  activities: activity list
}

val write_user :
  Bi_outbuf.t -> user -> unit
  (** Output a JSON value of type {!user}. *)

val string_of_user :
  ?len:int -> user -> string
  (** Serialize a value of type {!user}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_user :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> user
  (** Input JSON data of type {!user}. *)

val user_of_string :
  string -> user
  (** Deserialize JSON data of type {!user}. *)

val write_role :
  Bi_outbuf.t -> role -> unit
  (** Output a JSON value of type {!role}. *)

val string_of_role :
  ?len:int -> role -> string
  (** Serialize a value of type {!role}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_role :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> role
  (** Input JSON data of type {!role}. *)

val role_of_string :
  string -> role
  (** Deserialize JSON data of type {!role}. *)

val write_guild :
  Bi_outbuf.t -> guild -> unit
  (** Output a JSON value of type {!guild}. *)

val string_of_guild :
  ?len:int -> guild -> string
  (** Serialize a value of type {!guild}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_guild :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> guild
  (** Input JSON data of type {!guild}. *)

val guild_of_string :
  string -> guild
  (** Deserialize JSON data of type {!guild}. *)

val write_activity :
  Bi_outbuf.t -> activity -> unit
  (** Output a JSON value of type {!activity}. *)

val string_of_activity :
  ?len:int -> activity -> string
  (** Serialize a value of type {!activity}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_activity :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> activity
  (** Input JSON data of type {!activity}. *)

val activity_of_string :
  string -> activity
  (** Deserialize JSON data of type {!activity}. *)

val write_t :
  Bi_outbuf.t -> t -> unit
  (** Output a JSON value of type {!t}. *)

val string_of_t :
  ?len:int -> t -> string
  (** Serialize a value of type {!t}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_t :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> t
  (** Input JSON data of type {!t}. *)

val t_of_string :
  string -> t
  (** Deserialize JSON data of type {!t}. *)

