open Async

include module type of Message_t

val add_reaction : t -> Emoji.t -> unit Deferred.Or_error.t
val remove_reaction : t -> Emoji.t -> User_t.t -> unit Deferred.Or_error.t
val clear_reactions : t -> unit Deferred.Or_error.t
val delete : t -> unit Deferred.Or_error.t
val pin : t -> unit Deferred.Or_error.t
val unpin : t -> unit Deferred.Or_error.t
val reply : t -> string -> t Deferred.Or_error.t
val reply_with :
    ?embed:Embed.t ->
    ?content:string ->
    ?file:string ->
    ?tts:bool ->
    t ->
    Message_t.t Deferred.Or_error.t
val set_content : t -> string -> t Deferred.Or_error.t
val set_embed : t -> Embed.t -> t Deferred.Or_error.t