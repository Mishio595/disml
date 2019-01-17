include module type of User_t

val tag : t -> string
val mention : t -> string
val default_avatar : t -> string
val face : t -> string
(* val private_channel : t -> Channel_t.t *)
(* val send : t -> Yojson.Safe.json Deferred.Or_error.t *)