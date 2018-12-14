(* Auto-generated from "presence.atd" *)
[@@@ocaml.warning "-27-32-35-39"]

type user = User_t.t

type snowflake = Snowflake_t.t

type partial_user = User_t.partial_user

type activity = Activity_t.t

type t = Presence_t.t = {
  user: partial_user;
  roles: snowflake list;
  game: activity option;
  guild_id: snowflake;
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

val write_snowflake :
  Bi_outbuf.t -> snowflake -> unit
  (** Output a JSON value of type {!snowflake}. *)

val string_of_snowflake :
  ?len:int -> snowflake -> string
  (** Serialize a value of type {!snowflake}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_snowflake :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> snowflake
  (** Input JSON data of type {!snowflake}. *)

val snowflake_of_string :
  string -> snowflake
  (** Deserialize JSON data of type {!snowflake}. *)

val write_partial_user :
  Bi_outbuf.t -> partial_user -> unit
  (** Output a JSON value of type {!partial_user}. *)

val string_of_partial_user :
  ?len:int -> partial_user -> string
  (** Serialize a value of type {!partial_user}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_partial_user :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> partial_user
  (** Input JSON data of type {!partial_user}. *)

val partial_user_of_string :
  string -> partial_user
  (** Deserialize JSON data of type {!partial_user}. *)

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

