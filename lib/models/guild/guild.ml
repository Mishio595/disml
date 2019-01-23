open Core
open Async

include Guild_t
include Impl.Guild(Guild_t)

let get_member ~id guild =
    match List.find ~f:(fun m -> m.user.id = id) guild.members with
    | Some m -> Deferred.Or_error.return m
    | None -> Http.get_member (get_id guild) id >>| Result.map ~f:Member_t.of_yojson_exn

let get_channel ~id guild =
    match List.find ~f:(fun c -> Channel_t.get_id c = id) guild.channels with
    | Some c -> Deferred.Or_error.return c
    | None -> Http.get_channel id >>| Result.map ~f:(fun c -> Channel_t.(channel_wrapper_of_yojson_exn c |> wrap))

(* TODO add HTTP fallback *)
let get_role ~id guild =
    List.find ~f:(fun r -> r.id = id) guild.roles