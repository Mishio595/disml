open Async
include Client_options
include Dispatch

type t = {
    sharder: Sharder.t;
    token: string;
}

let start ?count token =
    Client_options.token := token;
    Sharder.start ?count ()
    >>| fun sharder ->
    { sharder; token; }

let set_status ~status client =
    Sharder.set_status ~status client.sharder

let set_status_with ~f client =
    Sharder.set_status_with ~f client.sharder

let request_guild_members ~guild ?query ?limit client =
    Sharder.request_guild_members ~guild ?query ?limit client.sharder