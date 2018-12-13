(* Auto-generated from "message.atd" *)
[@@@ocaml.warning "-27-32-35-39"]

type user = User_t.t

type snowflake = Snowflake_t.t

type role = Role_t.t

type reaction = Reaction_t.t

type member = Member_t.t

type embed = Embed_t.t

type attachment = Attachment_t.t

type t = Message_t.t = {
  id: snowflake;
  author: user;
  channel_id: snowflake;
  member: member option;
  guild_id: snowflake option;
  content: string;
  timestamp: string;
  edited_timestamp: string option;
  tts: bool;
  mention_everyone: bool;
  mentions: user list;
  role_mentions: role list;
  attachments: attachment list;
  embeds: embed list;
  reactions: reaction list;
  nonce: snowflake option;
  pinned: bool;
  webhook_id: snowflake;
  kind: int
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

val write_reaction :
  Bi_outbuf.t -> reaction -> unit
  (** Output a JSON value of type {!reaction}. *)

val string_of_reaction :
  ?len:int -> reaction -> string
  (** Serialize a value of type {!reaction}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_reaction :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> reaction
  (** Input JSON data of type {!reaction}. *)

val reaction_of_string :
  string -> reaction
  (** Deserialize JSON data of type {!reaction}. *)

val write_member :
  Bi_outbuf.t -> member -> unit
  (** Output a JSON value of type {!member}. *)

val string_of_member :
  ?len:int -> member -> string
  (** Serialize a value of type {!member}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_member :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> member
  (** Input JSON data of type {!member}. *)

val member_of_string :
  string -> member
  (** Deserialize JSON data of type {!member}. *)

val write_embed :
  Bi_outbuf.t -> embed -> unit
  (** Output a JSON value of type {!embed}. *)

val string_of_embed :
  ?len:int -> embed -> string
  (** Serialize a value of type {!embed}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_embed :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> embed
  (** Input JSON data of type {!embed}. *)

val embed_of_string :
  string -> embed
  (** Deserialize JSON data of type {!embed}. *)

val write_attachment :
  Bi_outbuf.t -> attachment -> unit
  (** Output a JSON value of type {!attachment}. *)

val string_of_attachment :
  ?len:int -> attachment -> string
  (** Serialize a value of type {!attachment}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_attachment :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> attachment
  (** Input JSON data of type {!attachment}. *)

val attachment_of_string :
  string -> attachment
  (** Deserialize JSON data of type {!attachment}. *)

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

