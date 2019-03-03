include module type of Guild_t

val ban_user : id:Snowflake.t -> ?reason:string -> ?days:int -> t -> (unit, string) Lwt_result.t
val create : (string * Yojson.Safe.t) list -> (t, string) Lwt_result.t
val create_emoji : name:string -> image:string -> t -> (Emoji.t, string) Lwt_result.t
val create_role :
    name:string ->
    ?colour:int ->
    ?permissions:int ->
    ?hoist:bool ->
    ?mentionable:bool ->
    t ->
    (Role_t.t, string) Lwt_result.t
val create_channel : mode:[ `Text | `Voice | `Category ] -> name:string -> t -> (Channel_t.t, string) Lwt_result.t
val delete : t -> (unit, string) Lwt_result.t
val get_ban : id:Snowflake.t -> t -> (Ban_t.t, string) Lwt_result.t
val get_bans : t -> (Ban_t.t list, string) Lwt_result.t
val get_emoji : id:Snowflake.t -> t -> (Emoji.t, string) Lwt_result.t
val get_invites : t -> (Yojson.Safe.t, string) Lwt_result.t
val get_prune_count : days:int -> t -> (int, string) Lwt_result.t
val get_webhooks : t -> (Yojson.Safe.t, string) Lwt_result.t
val kick_user : id:Snowflake.t -> ?reason:string -> t -> (unit, string) Lwt_result.t
val leave : t -> (unit, string) Lwt_result.t
val list_voice_regions : t -> (Yojson.Safe.t, string) Lwt_result.t
val prune : days:int -> t -> (int, string) Lwt_result.t
val request_members : t -> (Member_t.t list, string) Lwt_result.t
val set_afk_channel : id:Snowflake.t -> t -> (Guild_t.t, string) Lwt_result.t
val set_afk_timeout : timeout:int -> t -> (Guild_t.t, string) Lwt_result.t
val set_name : name:string -> t -> (Guild_t.t, string) Lwt_result.t
val set_icon : icon:string -> t -> (Guild_t.t, string) Lwt_result.t
val unban_user : id:Snowflake.t -> ?reason:string -> t -> (unit, string) Lwt_result.t

(** Get a channel belonging to this guild. This does not make an HTTP request. *)
val get_channel : id:Channel_id_t.t -> t -> (Channel_t.t, string) Lwt_result.t

(** Get a member belonging to this guild. This does not make an HTTP request. *)
val get_member : id:User_id_t.t -> t -> (Member_t.t, string) Lwt_result.t

(** Get a role belonging to this guild. This does not make an HTTP request. *)
val get_role : id:Role_id.t -> t -> Role_t.t option