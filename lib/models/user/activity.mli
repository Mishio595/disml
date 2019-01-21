type t = {
    name: string;
    kind: int;
    url: string;
} [@@deriving sexp, yojson]