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
  mentionable: bool
}

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

