type t = {
    reason: string [@default ""];
    user: User_t.t;
} [@@deriving yojson { strict = false}]