open Async
include Dispatch

type t = {
    sharder: Sharder.t;
}

let start ?count ?compress ?(large=250) token =
    Client_options.token := token;
    Sharder.start ?count ?compress ~large_threshold:large ()
    >>| fun sharder ->
    { sharder; }

let set_status ~status client =
    Sharder.set_status ~status client.sharder

let set_status_with ~f client =
    Sharder.set_status_with ~f client.sharder

let request_guild_members ~guild ?query ?limit client =
    Sharder.request_guild_members ~guild ?query ?limit client.sharder