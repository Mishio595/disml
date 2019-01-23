(** A footer object belonging to an embed. *)
type footer = {
    text: string;
    icon_url: string option;
    proxy_icon_url: string option;
} [@@deriving sexp, yojson]

(** An image object belonging to an embed. *)
type image = {
    url: string option;
    proxy_url: string option;
    height: int option;
    width: int option;
} [@@deriving sexp, yojson]

(** A video object belonging to an embed. *)
type video = {
    url: string option;
    height: int option;
    width: int option;
} [@@deriving sexp, yojson]

(** A provider object belonging to an embed. *)
type provider = {
    name: string option;
    url: string option;
} [@@deriving sexp, yojson]

(** An author object belonging to an embed. *)
type author = {
    name: string option;
    url: string option;
    icon_url: string option;
    proxy_icon_url: string option;
} [@@deriving sexp, yojson]

(** A field object belonging to an embed. *)
type field = {
    name: string;
    value: string;
    inline: bool;
} [@@deriving sexp, yojson]

(** An embed object. See this {{:https://leovoel.github.io/embed-visualizer/}embed visualiser} if you need help understanding each component. *)
type t = {
    title: string option;
    kind: string option[@key "type"];
    description: string option;
    url: string option;
    timestamp: string option;
    colour: int option[@key "color"];
    footer: footer option;
    image: image option;
    thumbnail: image option;
    video: video option;
    provider: provider option;
    author: author option;
    fields: field list [@default []];
} [@@deriving sexp, yojson { strict = false }]

(** An embed where all values are empty. *)
val default : t

(** A footer where all values are empty. *)
val default_footer : footer

(** An image where all values are empty. *)
val default_image : image

(** A video where all values are empty. *)
val default_video : video

(** A provider where all values are empty. *)
val default_provider : provider

(** An author where all values are empty. *)
val default_author : author

(** Set the title of an embed. *)
val title : string -> t -> t

(** Set the description of an embed. *)
val description : string -> t -> t

(** Set the URL of an embed. *)
val url : string -> t -> t

(** Set the timestamp of an embed. *)
val timestamp : string -> t -> t

(** Set the colour of an embed. *)
val colour : int -> t -> t

(** Identical to {!colour} but with US English spelling. *)
val color : int -> t -> t

(** Set the footer of an embed. The function passes {!default_footer} and must return a footer. *)
val footer : (footer -> footer) -> t -> t

(** Set the image URL of an embed. *)
val image : string -> t -> t

(** Set the thumbnail URL of an embed. *)
val thumbnail : string -> t -> t

(** Set the author of an embed. The function passes {!default_author} and must return an author. *)
val author : (author -> author) -> t -> t

(** Add a field to an embed. Takes a tuple in [(name, value, inline)] order. {b Fields added this way will appear in reverse order in the embed.} *)
val field : string * string * bool -> t -> t

(** Set the fields of an embed. Similar to {!val:field}, but because a complete list is passed, fields preserve order. *)
val fields : (string * string * bool) list -> t -> t

(** Set the footer text. Typically used in the closure passed to {!val:footer}. *)
val footer_text : string -> footer -> footer

(** Set the footer icon URL. Typically used in the closure passed to {!val:footer}. *)
val footer_icon : string -> footer -> footer

(** Set the author name. Typically used in the closure passed to {!val:author}. *)
val author_name : string -> author -> author

(** Set the author URL. Typically used in the closure passed to {!val:author}. *)
val author_url : string -> author -> author

(** Set the author icon URL. Typically used in the closure passed to {!val:author}. *)
val author_icon : string -> author -> author