open Core

type t = {
    name: string;
    kind: int [@key "type"];
    url: string [@default ""];
} [@@deriving sexp, yojson { strict = false}]