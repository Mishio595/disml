open Async

module type HasSnowflake = sig
    type t [@@deriving sexp, yojson]
    val get_id : t -> Snowflake.t
end

module type ChannelImpl = sig
    type t
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
    (* TODO more things related to guild channels *)
end

module type GuildImpl = sig
    open Async

    type t
    val ban_user : id:Snowflake.t -> ?reason:string -> ?days:int -> t -> unit Deferred.Or_error.t
    val create_emoji : name:string -> image:string -> t -> Emoji.t Deferred.Or_error.t
    val create_role :
        name:string ->
        ?colour:int ->
        ?permissions:int ->
        ?hoist:bool ->
        ?mentionable:bool ->
        t ->
        Role_t.t Deferred.Or_error.t
    val create_channel : mode:[ `Text | `Voice | `Category ] -> name:string -> t -> Channel_t.t Deferred.Or_error.t
    val delete : t -> unit Deferred.Or_error.t
    val get_ban : id:Snowflake.t -> t -> Ban_t.t Deferred.Or_error.t
    val get_bans : t -> Ban_t.t list Deferred.Or_error.t
    val get_emoji : id:Snowflake.t -> t -> Emoji.t Deferred.Or_error.t
    val get_invites : t -> Yojson.Safe.json Deferred.Or_error.t
    val get_prune_count : days:int -> t -> int Deferred.Or_error.t
    val get_webhooks : t -> Yojson.Safe.json Deferred.Or_error.t
    val kick_user : id:Snowflake.t -> ?reason:string -> t -> unit Deferred.Or_error.t
    val leave : t -> unit Deferred.Or_error.t
    val list_voice_regions : t -> Yojson.Safe.json Deferred.Or_error.t
    val prune : days:int -> t -> int Deferred.Or_error.t
    val request_members : t -> Member_t.t list Deferred.Or_error.t
    val set_afk_channel : id:Snowflake.t -> t -> Guild_t.t Deferred.Or_error.t
    val set_afk_timeout : timeout:int -> t -> Guild_t.t Deferred.Or_error.t
    val set_name : name:string -> t -> Guild_t.t Deferred.Or_error.t
    val set_icon : icon:string -> t -> Guild_t.t Deferred.Or_error.t
    val unban_user : id:Snowflake.t -> ?reason:string -> t -> unit Deferred.Or_error.t
end

module type UserImpl = sig
    type t
    (* val private_channel : t -> Channel_t.t *)
    (* val send : t -> Yojson.Safe.json Deferred.Or_error.t *)
end