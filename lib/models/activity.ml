type t = {
    name: string;
    kind: int [@key "type"];
    url: string [@default ""];
} [@@deriving yojson { strict = false}]