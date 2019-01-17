open Async

type t = {
    sharder: Sharder.t;
    token: string;
}

let start ?count token =
    Config.token := token;
    Sharder.start ?count ()
    >>| fun sharder ->
    { sharder; token = !Config.token; }

let set_status ~status client =
    Sharder.set_status ~status client.sharder

let set_status_with ~f client =
    Sharder.set_status_with ~f client.sharder

let request_guild_members ~guild ?query ?limit client =
    Sharder.request_guild_members ~guild ?query ?limit client.sharder