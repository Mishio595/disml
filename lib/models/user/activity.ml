open Core

type t = {
    name: string;
    kind: int [@key "type"];
    url: string option [@default None];
} [@@deriving sexp, yojson { strict = false; exn = true }]