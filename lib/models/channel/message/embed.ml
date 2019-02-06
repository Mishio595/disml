open Core

type footer = {
    text: string;
    icon_url: string option [@default None];
    proxy_icon_url: string option [@default None];
} [@@deriving sexp, yojson { strict = false;  exn = true }]

type image = {
    url: string option [@default None];
    proxy_url: string option [@default None];
    height: int option [@default None];
    width: int option [@default None];
} [@@deriving sexp, yojson { strict = false;  exn = true }]

type video = {
    url: string option [@default None];
    height: int option [@default None];
    width: int option [@default None];
} [@@deriving sexp, yojson { strict = false;  exn = true }]

type provider = {
    name: string option [@default None];
    url: string option [@default None];
} [@@deriving sexp, yojson { strict = false;  exn = true }]

type author = {
    name: string option [@default None];
    url: string option [@default None];
    icon_url: string option [@default None];
    proxy_icon_url: string option [@default None];
} [@@deriving sexp, yojson { strict = false;  exn = true }]

type field = {
    name: string;
    value: string;
    inline: bool [@default false];
} [@@deriving sexp, yojson { strict = false;  exn = true }]

type t = {
    title: string option [@default None];
    kind: string option [@default None][@key "type"];
    description: string option [@default None];
    url: string option [@default None];
    timestamp: string option [@default None];
    colour: int option [@default None][@key "color"];
    footer: footer option [@default None];
    image: image option [@default None];
    thumbnail: image option [@default None];
    video: video option [@default None];
    provider: provider option [@default None];
    author: author option [@default None];
    fields: field list [@default []];
} [@@deriving sexp, yojson { strict = false; exn = true }]

let default = {
    title = None;
    kind = None;
    description = None;
    url = None;
    timestamp = None;
    colour = None;
    footer = None;
    image = None;
    thumbnail = None;
    video = None;
    provider = None;
    author = None;
    fields = [];
}

let default_footer = {
    text = "";
    icon_url = None;
    proxy_icon_url = None;
}

let default_image = {
    url = None;
    proxy_url = None;
    height = None;
    width = None;
}

let default_video = {
    url = None;
    width = None;
    height = None;
}

let default_provider = {
    name = None;
    url = None;
}

let default_author = {
    name = None;
    url = None;
    icon_url = None;
    proxy_icon_url = None;
}

let title v e = { e with title = Some v }
let description v e = { e with description = Some v }
let url v e = { e with url = Some v }
let timestamp v e = { e with timestamp = Some v }
let colour v e = { e with colour = Some v }
let color v e = { e with colour = Some v }
let footer f e = { e with footer = Some (f default_footer) }
let image v e = { e with image = Some { default_image with url = Some v } }
let thumbnail v e = { e with thumbnail = Some { default_image with url = Some v } }
let author f e = { e with author = Some (f default_author) }
let field (name, value, inline) e = { e with fields = { name; value; inline; }::e.fields }
let fields l e = { e with fields = List.map ~f:(fun (name, value, inline) -> { name; value; inline; }) l }

let footer_text v f : footer = { f with text = v }
let footer_icon v f : footer = { f with icon_url = Some v }

let author_name v a : author = { a with name = Some v }
let author_url v a : author = { a with url = Some v }
let author_icon v a : author = { a with icon_url = Some v }