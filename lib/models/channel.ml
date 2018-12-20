let id (ch:Channel_t.t) = match ch with
| `Group g -> g.id
| `Private p -> p.id
| `GuildText t -> t.id
| `GuildVoice v -> v.id
| `Category c -> c.id

module Make(Http : S.Http) = struct
    (* open Channel_t *)

    type t = Channel_t.t
end