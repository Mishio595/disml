open Async
include module type of Channel_t

exception Invalid_message
exception No_message_found

(** Simple version of send_message that only takes [~content] *)
val say : content:string -> t -> Message_t.t Deferred.Or_error.t

(** Advanced message sending.

    Raises {!Channel.Invalid_message} if one of content or embed is not set.

    {3 Examples}
    {[
        open Core
        open Disml

        let check_command (msg : Message.t) =
            if String.is_prefix ~prefix:"!hello" msg.content then
                let embed = { Embed.default with title = Some "Hello World!" } in
                Channel.send_message ~embed msg.channel >>> ignore

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