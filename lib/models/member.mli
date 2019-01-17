open Async

include module type of Member_t

val add_role : role:Role_t.t -> Member_t.t -> unit Deferred.Or_error.t
val remove_role : role:Role_t.t -> Member_t.t -> unit Deferred.Or_error.t
val ban : ?reason:string -> ?days:int -> Member_t.t -> unit Deferred.Or_error.t
val kick : ?reason:string -> Member_t.t -> unit Deferred.Or_error.t
val mute : Member_t.t -> unit Deferred.Or_error.t
val deafen : Member_t.t -> unit Deferred.Or_error.t
val unmute : Member_t.t -> unit Deferred.Or_error.t
val undeafen : Member_t.t -> unit Deferred.Or_error.t