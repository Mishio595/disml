open Async

module Make(T : S.Token)(H : S.Handler) = struct
    include T

    module Http = Http.Make(T)
    module Dispatch = Dispatch.Make(H)
    module Sharder = Sharder.Make(Http)(Dispatch)

    type t = {
        sharder: Sharder.t Ivar.t;
        token: string;
    }

    let init () =
        {
            sharder = Ivar.create ();
            token;
        }

    let start ?count client =
        Sharder.start ?count ()
        >>| fun sharder ->
        Ivar.fill_if_empty client.sharder sharder;
        client

    let set_status ~status client =
        Ivar.read client.sharder
        >>= fun sharder ->
        Sharder.set_status ~status sharder

    let set_status_with ~f client =
        Ivar.read client.sharder
        >>= fun sharder ->
        Sharder.set_status_with ~f sharder

    let request_guild_members ~guild ?query ?limit client =
        Ivar.read client.sharder
        >>= fun sharder ->
        Sharder.request_guild_members ~guild ?query ?limit sharder
end