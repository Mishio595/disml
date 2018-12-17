(* Auto-generated from "role.atd" *)
[@@@ocaml.warning "-27-32-35-39"]

type snowflake = Snowflake_t.t

type t = Role_t.t = {
  id: snowflake;
  name: string;
  colour: int;
  hoist: bool;
  position: int;
  permissions: int;
  managed: bool;
  mentionable: bool;
  guild_id: snowflake
}

type role = Role_t.role = {
  id: snowflake;
  name: string;
  colour: int;
  hoist: bool;
  position: int;
  permissions: int;
  managed: bool;
  mentionable: bool
}

type role_update = Role_t.role_update = { role: role; id: snowflake }

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

val write_role_update :
  Bi_outbuf.t -> role_update -> unit
  (** Output a JSON value of type {!role_update}. *)

val string_of_role_update :
  ?len:int -> role_update -> string
  (** Serialize a value of type {!role_update}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_role_update :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> role_update
  (** Input JSON data of type {!role_update}. *)

val role_update_of_string :
  string -> role_update
  (** Deserialize JSON data of type {!role_update}. *)

