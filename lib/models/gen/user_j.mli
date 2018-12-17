(* Auto-generated from "user.atd" *)
[@@@ocaml.warning "-27-32-35-39"]

type snowflake = Snowflake_t.t

type t = User_t.t = {
  id: snowflake;
  username: string;
  discriminator: int;
  avatar: string option;
  bot: bool
}

type partial_user = User_t.partial_user = { id: snowflake }

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

