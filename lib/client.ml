open Async
include Dispatch

type t =
{ sharder: Sharder.t
}

let start ?count ?compress ?(large=250) token =
    Client_options.token := token;
    Sharder.start ?count ?compress ~large_threshold:large ()
    >>| fun sharder ->
    { sharder; }

let set_status ?status ?kind ?name ?since ?url client =
    Sharder.set_status ?status ?kind ?name ?since ?url client.sharder

let request_guild_members ~guild ?query ?limit client =
    let `Guild_id guild = guild in
    Sharder.request_guild_members ~guild ?query ?limit client.sharder

let shutdown_all ?restart client =
    Sharder.shutdown_all ?restart client.sharder