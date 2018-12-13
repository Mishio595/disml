(* Auto-generated from "embed.atd" *)
[@@@ocaml.warning "-27-32-35-39"]

type video = Embed_t.video = {
  url: string option;
  height: int option;
  width: int option
}

type provider = Embed_t.provider = {
  name: string option;
  url: string option
}

type image = Embed_t.image = {
  url: string option;
  proxy_url: string option;
  height: int option;
  width: int option
}

type footer = Embed_t.footer = {
  text: string;
  icon_url: string option;
  proxy_icon_url: string option
}

type field = Embed_t.field = {
  name: string;
  value: string;
  inline: bool option
}

type t = Embed_t.t = {
  title: string option;
  kind: string option;
  description: string option;
  url: string option;
  timestamp: string option;
  colour: int option;
  footer: footer option;
  image: image option;
  thumbnail: image option;
  video: video option;
  provider: provider option;
  fields: field list option
}

val write_video :
  Bi_outbuf.t -> video -> unit
  (** Output a JSON value of type {!video}. *)

val string_of_video :
  ?len:int -> video -> string
  (** Serialize a value of type {!video}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_video :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> video
  (** Input JSON data of type {!video}. *)

val video_of_string :
  string -> video
  (** Deserialize JSON data of type {!video}. *)

val write_provider :
  Bi_outbuf.t -> provider -> unit
  (** Output a JSON value of type {!provider}. *)

val string_of_provider :
  ?len:int -> provider -> string
  (** Serialize a value of type {!provider}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_provider :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> provider
  (** Input JSON data of type {!provider}. *)

val provider_of_string :
  string -> provider
  (** Deserialize JSON data of type {!provider}. *)

val write_image :
  Bi_outbuf.t -> image -> unit
  (** Output a JSON value of type {!image}. *)

val string_of_image :
  ?len:int -> image -> string
  (** Serialize a value of type {!image}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_image :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> image
  (** Input JSON data of type {!image}. *)

val image_of_string :
  string -> image
  (** Deserialize JSON data of type {!image}. *)

val write_footer :
  Bi_outbuf.t -> footer -> unit
  (** Output a JSON value of type {!footer}. *)

val string_of_footer :
  ?len:int -> footer -> string
  (** Serialize a value of type {!footer}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_footer :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> footer
  (** Input JSON data of type {!footer}. *)

val footer_of_string :
  string -> footer
  (** Deserialize JSON data of type {!footer}. *)

val write_field :
  Bi_outbuf.t -> field -> unit
  (** Output a JSON value of type {!field}. *)

val string_of_field :
  ?len:int -> field -> string
  (** Serialize a value of type {!field}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_field :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> field
  (** Input JSON data of type {!field}. *)

val field_of_string :
  string -> field
  (** Deserialize JSON data of type {!field}. *)

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

