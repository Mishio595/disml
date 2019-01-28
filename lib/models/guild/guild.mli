open Async

include module type of Guild_t
include S.GuildImpl with
    type t := Guild_t.t

(** Get a channel belonging to this guild. This does not make an HTTP request. *)
val get_channel : id:Channel_id_t.t -> t -> Channel_t.t Deferred.Or_error.t

(** Get a member belonging to this guild. This does not make an HTTP request. *)
val get_member : id:User_id_t.t -> t -> Member_t.t Deferred.Or_error.t

(** Get a role belonging to this guild. This does not make an HTTP request. *)
val get_role : id:Role_id.t -> t -> Role_t.t option