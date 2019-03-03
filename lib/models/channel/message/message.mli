include module type of Message_t

(** Add the given emoji as a reaction. *)
val add_reaction : t -> Emoji.t -> (unit, string) Lwt_result.t

(** Remove the reaction. Must also specify the user. *)
val remove_reaction : t -> Emoji.t -> User_t.t -> (unit, string) Lwt_result.t

(** Remove all reactions from the message. *)
val clear_reactions : t -> (unit, string) Lwt_result.t

(** Delete the message. *)
val delete : t -> (unit, string) Lwt_result.t

(** Pin the message. *)
val pin : t -> (unit, string) Lwt_result.t

(** Unping the message. *)
val unpin : t -> (unit, string) Lwt_result.t

(** Sugar for [Channel_id.say msg.channel_id content]. *)
val reply : t -> string -> (t, string) Lwt_result.t

(** Sugar for [Channel_id.send_message ?embed ?content ?file ?tts msg.channel_id]. *)
val reply_with :
    ?embed:Embed.t ->
    ?content:string ->
    ?file:string ->
    ?tts:bool ->
    t ->
    (Message_t.t, string) Lwt_result.t

(** Set the content of the message. *)
val set_content : t -> string -> (t, string) Lwt_result.t

(** Set the embed of the message. *)
val set_embed : t -> Embed.t -> (t, string) Lwt_result.t
