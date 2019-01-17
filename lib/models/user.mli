type t = User_t.t
val tag : t -> string
val mention : t -> string
val default_avatar : t -> string
val face : t -> string
(* val private_channel : t -> Channel_t.t *)
(* val send : t -> Yojson.Safe.json Deferred.Or_error.t *)