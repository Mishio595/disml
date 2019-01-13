module Make(T : S.Token)(H : S.Handler_f) = struct
    open Async

    module Http = Http.Make(T)
    module Models = Models.Make(Http)
    module Handler = H.Make(Models)
    module Dispatch = Dispatch.Make(Handler)
    module Sharder = Sharder.Make(Http)(Dispatch)

    type t = {
        sharder: Sharder.t;
        token: string;
    }

    let token = T.token

    let start ?count () =
        Sharder.start ?count ()
        >>| fun sharder ->
        { sharder; token; }

    let set_status ~status client =
        Sharder.set_status ~status client.sharder

    let set_status_with ~f client =
        Sharder.set_status_with ~f client.sharder

    let request_guild_members ~guild ?query ?limit client =
        Sharder.request_guild_members ~guild ?query ?limit client.sharder
end