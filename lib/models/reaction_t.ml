type t = {
    count: int;
    emoji: Emoji.t;
} [@@deriving yojson { strict = false}]