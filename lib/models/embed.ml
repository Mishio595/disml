type footer = {
    text: string;
    icon_url: string option [@default None];
    proxy_icon_url: string option [@default None];
} [@@deriving yojson]

type image = {
    url: string option [@default None];
    proxy_url: string option [@default None];
    height: int option [@default None];
    width: int option [@default None];
} [@@deriving yojson]

type video = {
    url: string option [@default None];
    height: int option [@default None];
    width: int option [@default None];
} [@@deriving yojson]

type provider = {
    name: string option [@default None];
    url: string option [@default None];
} [@@deriving yojson]

type field = {
    name: string;
    value: string;
    inline: bool option [@default None];
} [@@deriving yojson]

type t = {
    title: string option [@default None];
    kind: string option [@default None];
    description: string option [@default None];
    url: string option [@default None];
    timestamp: string option [@default None];
    colour: int option [@default None];
    footer: footer option [@default None];
    image: image option [@default None];
    thumbnail: image option [@default None];
    video: video option [@default None];
    provider: provider option [@default None];
    fields: field list [@default []];
} [@@deriving yojson]