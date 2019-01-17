open Async

type t = Message_t.t
val add_reaction : t -> Emoji.t -> Yojson.Safe.json Deferred.Or_error.t
val remove_reaction : t -> Emoji.t -> User_t.t -> Yojson.Safe.json Deferred.Or_error.t
val clear_reactions : t -> Yojson.Safe.json Deferred.Or_error.t
val delete : t -> Yojson.Safe.json Deferred.Or_error.t
val pin : t -> Yojson.Safe.json Deferred.Or_error.t
val unpin : t -> Yojson.Safe.json Deferred.Or_error.t
val reply : t -> string -> Yojson.Safe.json Deferred.Or_error.t
val set_content : t -> string -> Yojson.Safe.json Deferred.Or_error.t
val set_embed : t -> Embed.t -> Yojson.Safe.json Deferred.Or_error.t