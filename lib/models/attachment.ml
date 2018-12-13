type t = {
    id: Snowflake.t;
    filename: string;
    size: int;
    url: string;
    proxy_url: string;
    height: int option;
    width: int option;
} [@@deriving yojson]