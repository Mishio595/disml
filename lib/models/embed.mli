type footer = {
    text: string;
    icon_url: string option;
    proxy_icon_url: string option;
} [@@deriving sexp, yojson]

type image = {
    url: string option;
    proxy_url: string option;
    height: int option;
    width: int option;
} [@@deriving sexp, yojson]

type video = {
    url: string option;
    height: int option;
    width: int option;
} [@@deriving sexp, yojson]

type provider = {
    name: string option;
    url: string option;
} [@@deriving sexp, yojson]

type author = {
    name: string option;
    url: string option;
    icon_url: string option;
    proxy_icon_url: string option;
} [@@deriving sexp, yojson]

type field = {
    name: string;
    value: string;
    inline: bool;
} [@@deriving sexp, yojson]

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

val default : t
val default_footer : footer
val default_image : image
val default_video : video
val default_provider : provider
val default_author : author

val title : string -> t -> t
val description : string -> t -> t
val url : string -> t -> t
val timestamp : string -> t -> t
val colour : int -> t -> t
val color : int -> t -> t
val footer : (footer -> footer) -> t -> t
val image : string -> t -> t
val thumbnail : string -> t -> t
val author : (author -> author) -> t -> t
val field : string * string * bool -> t -> t
val fields : (string * string * bool) list -> t -> t

val footer_text : string -> footer -> footer
val footer_icon : string -> footer -> footer

val author_name : string -> author -> author
val author_url : string -> author -> author
val author_icon : string -> author -> author