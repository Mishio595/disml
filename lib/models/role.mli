open Async

include module type of Role_t

val allow_mention : t -> Yojson.Safe.json Deferred.Or_error.t
val delete : t -> Yojson.Safe.json Deferred.Or_error.t
val disallow_mention : t -> Yojson.Safe.json Deferred.Or_error.t
val hoist : t -> Yojson.Safe.json Deferred.Or_error.t
val set_colour : colour:int -> t -> Yojson.Safe.json Deferred.Or_error.t
val set_name : name:string -> t -> Yojson.Safe.json Deferred.Or_error.t
val unhoist : t -> Yojson.Safe.json Deferred.Or_error.t