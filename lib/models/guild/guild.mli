open Async

include module type of Guild_t
include S.GuildImpl with
    type t := Guild_t.t

val get_channel : id:Channel_id_t.t -> t -> Channel_t.t Deferred.Or_error.t
val get_member : id:User_id_t.t -> t -> Member_t.t Deferred.Or_error.t
val get_role : id:Role_id.t -> t -> Role_t.t option