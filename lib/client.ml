open Async

type t = {
    sharder: Sharder.t Ivar.t;
    handler: string Pipe.Writer.t;
    token: string;
}

let create ~handler token =
    {
        sharder = Ivar.create ();
        handler;
        token;
    }

let start ?count client =
    Sharder.start ?count client.token
    >>| fun sharder ->
    Ivar.fill_if_empty client.sharder sharder;
    client

let set_status ~status client =
    Ivar.read client.sharder
    >>= fun sharder ->
    Sharder.set_status sharder status

let set_status_with ~f client =
    Ivar.read client.sharder
    >>= fun sharder ->
    Sharder.set_status_with sharder f

let request_guild_members ~guild ?query ?limit client =
    Ivar.read client.sharder
    >>= fun sharder ->
    Sharder.request_guild_members ~guild ?query ?limit sharder
