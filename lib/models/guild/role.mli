open Async

include module type of Role_t

val allow_mention : t -> t Deferred.Or_error.t
val delete : t -> unit Deferred.Or_error.t
val disallow_mention : t -> t Deferred.Or_error.t
val hoist : t -> t Deferred.Or_error.t
val set_colour : colour:int -> t -> t Deferred.Or_error.t
val set_name : name:string -> t -> t Deferred.Or_error.t
val unhoist : t -> t Deferred.Or_error.t