(* Auto-generated from "guild.atd" *)
[@@@ocaml.warning "-27-32-35-39"]

type user = User_t.t

type snowflake = Snowflake_t.t

type role = Role_t.role

type member = Member_t.t

type emoji = Emoji_t.t

type channel = Channel_t.t

type t = Guild_t.t = {
  id: snowflake;
  name: string;
  icon: string option;
  splash: string option;
  owner_id: snowflake;
  region: string;
  afk_channel_id: snowflake option;
  afk_timeout: int;
  embed_enabled: bool option;
  embed_channel_id: snowflake option;
  verification_level: int;
  default_message_notifications: int;
  explicit_content_filter: int;
  roles: role list;
  emojis: emoji list;
  features: string list;
  mfa_level: int;
  application_id: snowflake option;
  widget_enabled: bool option;
  widget_channel: channel option;
  system_channel: channel option;
  large: bool option;
  unavailable: bool option;
  member_count: int option;
  members: member list;
  channels: channel list
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

val write_channel :
  Bi_outbuf.t -> channel -> unit
  (** Output a JSON value of type {!channel}. *)

val string_of_channel :
  ?len:int -> channel -> string
  (** Serialize a value of type {!channel}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_channel :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> channel
  (** Input JSON data of type {!channel}. *)

val channel_of_string :
  string -> channel
  (** Deserialize JSON data of type {!channel}. *)

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

