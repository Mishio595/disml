open Async

include module type of Guild_t
include S.GuildImpl with
    type t := Guild_t.t

val get_channel : id:Snowflake.t -> t -> Channel_t.t Deferred.Or_error.t
val get_member : id:Snowflake.t -> t -> Member_t.t Deferred.Or_error.t
val get_role : id:Snowflake.t -> t -> Role_t.t option