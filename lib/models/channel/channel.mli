include module type of Channel_t

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
    (Message_t.t, string) Lwt_result.t

(** [say str ch] is equivalent to [send_message ~content:str ch]. *)
val say : string -> t -> (Message_t.t, string) Lwt_result.t

val delete : t -> (Channel_t.t, string) Lwt_result.t
val get_message : id:Snowflake.t -> t -> (Message_t.t, string) Lwt_result.t
val get_messages :
    ?mode:[ `Before | `After | `Around ] ->
    ?id:Snowflake.t ->
    ?limit:int ->
    t ->
    (Message_t.t list, string) Lwt_result.t
val broadcast_typing : t -> (unit, string) Lwt_result.t
val get_pins : t -> (Message_t.t list, string) Lwt_result.t
val bulk_delete : Snowflake.t list -> t -> (unit, string) Lwt_result.t
(* TODO more things related to guild channels *)
