type t = {
    id: Snowflake.t;
    kind: int;
    (* guild: Guild.t option; *)
    position: int option;
    permission_overwrites: (int list) option;
    name: string option;
    topic: string option;
    nsfw: bool option;
    bitrate: int option;
    user_limit: int option;
    recipients: (User.t list) option;
    icon: string option;
    owner_id: Snowflake.t option;
    application_id: Snowflake.t option;
    parent_id: Snowflake.t option;
} [@@deriving yojson]