(* Auto-generated from "reaction.atd" *)
[@@@ocaml.warning "-27-32-35-39"]

type emoji = Emoji_t.t

type t = Reaction_t.t = { count: int; emoji: emoji }

val write_emoji :
  Bi_outbuf.t -> emoji -> unit
  (** Output a JSON value of type {!emoji}. *)

val string_of_emoji :
  ?len:int -> emoji -> string
  (** Serialize a value of type {!emoji}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_emoji :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> emoji
  (** Input JSON data of type {!emoji}. *)

val emoji_of_string :
  string -> emoji
  (** Deserialize JSON data of type {!emoji}. *)

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

