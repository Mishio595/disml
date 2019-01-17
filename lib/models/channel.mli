open Async
include module type of Channel_t

val say : content:string -> t -> Message_t.t Deferred.Or_error.t
val send_message :
    ?embed:Yojson.Safe.json ->
    ?content:string ->
    ?file:string ->
    ?tts:bool ->
    t ->
    Message_t.t Deferred.Or_error.t
val delete : t -> unit Deferred.Or_error.t
val get_message : id:Snowflake.t -> t -> Message_t.t Deferred.Or_error.t
val get_messages :
    ?mode:[ `Before | `After | `Around ] ->
    ?id:Snowflake.t ->
    ?limit:int ->
    t ->
    Message_t.t list Deferred.Or_error.t
val broadcast_typing : t -> unit Deferred.Or_error.t
val get_pins : t -> Message_t.t list Deferred.Or_error.t
(* TODO more things related to guild channels *)