open Async
include Client_options
include Dispatch

type t = {
    sharder: Sharder.t;
}

let start ?count ?compress ?(large=250) token =
    Client_options.token := token;
    Client_options.large_threshold := large;
    Sharder.start ?count ?compress ()
    >>| fun sharder ->
    { sharder; }

let set_status ~status client =
    Sharder.set_status ~status client.sharder

let set_status_with ~f client =
    Sharder.set_status_with ~f client.sharder

let request_guild_members ~guild ?query ?limit client =
    Sharder.request_guild_members ~guild ?query ?limit client.sharder