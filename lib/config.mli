val token : string ref

val hello : (Yojson.Safe.json -> unit) ref
val ready : (Yojson.Safe.json -> unit) ref
val resumed : (Yojson.Safe.json -> unit) ref
val invalid_session : (Yojson.Safe.json -> unit) ref
val channel_create : (Channel_t.t -> unit) ref
val channel_update : (Channel_t.t -> unit) ref
val channel_delete : (Channel_t.t -> unit) ref
val channel_pins_update : (Yojson.Safe.json -> unit) ref
val guild_create : (Guild_t.t -> unit) ref
val guild_update : (Guild_t.t -> unit) ref
val guild_delete : (Guild_t.t -> unit) ref
val member_ban : (Ban_t.t -> unit) ref
val member_unban : (Ban_t.t -> unit) ref
val guild_emojis_update : (Yojson.Safe.json -> unit) ref
val integrations_update : (Yojson.Safe.json -> unit) ref
val member_join : (Member_t.t -> unit) ref
val member_leave : (Member_t.member_wrapper -> unit) ref
val member_update : (Member_t.member_update -> unit) ref
val members_chunk : (Member_t.t list -> unit) ref
val role_create : (Role_t.t -> unit) ref
val role_update : (Role_t.t -> unit) ref
val role_delete : (Role_t.t -> unit) ref
val message_create : (Message_t.t -> unit) ref
val message_update : (Message_t.message_update -> unit) ref
val message_delete : (Snowflake.t -> Snowflake.t -> unit) ref
val message_bulk_delete : (Snowflake.t list -> unit) ref
val reaction_add : (Reaction_t.reaction_event -> unit) ref
val reaction_remove : (Reaction_t.reaction_event -> unit) ref
val reaction_bulk_remove : (Reaction_t.t list -> unit) ref
val presence_update : (Presence.t -> unit) ref
val typing_start : (Yojson.Safe.json -> unit) ref
val user_update : (Yojson.Safe.json -> unit) ref
val voice_state_update : (Yojson.Safe.json -> unit) ref
val voice_server_update : (Yojson.Safe.json -> unit) ref
val webhooks_update : (Yojson.Safe.json -> unit) ref