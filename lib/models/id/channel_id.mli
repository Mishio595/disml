open Async
include module type of Channel_id_t

exception Invalid_message
exception No_message_found

(** Advanced message sending.

    Raises {!Invalid_message} if one of content or embed is not set.

    {3 Examples}
    {[
open Core
open Disml

let check_command (msg : Message.t) =
    if String.is_prefix ~prefix:"!hello" msg.content then
        let embed = Embed.(default |> title "Hello World!") in
        Channel_id.send_message ~embed msg.channel_id >>> ignore

Client.message_create := check_command
    ]}
*)
val send_message :
    ?embed:Embed.t ->
    ?content:string ->
    ?file:string ->
    ?tts:bool ->
    t ->
    Message_t.t Deferred.Or_error.t

(** [say str ch] is equivalent to [send_message ~content:str ch]. *)
val say : string -> t -> Message_t.t Deferred.Or_error.t

val delete : t -> Channel_t.t Deferred.Or_error.t
val get_message : id:Snowflake.t -> t -> Message_t.t Deferred.Or_error.t
val get_messages :
    ?mode:[ `Before | `After | `Around ] ->
    ?id:Snowflake.t ->
    ?limit:int ->
    t ->
    Message_t.t list Deferred.Or_error.t
val broadcast_typing : t -> unit Deferred.Or_error.t
val get_pins : t -> Message_t.t list Deferred.Or_error.t
val bulk_delete : Snowflake.t list -> t -> unit Deferred.Or_error.t
(* TODO more things related to guild channels *)
