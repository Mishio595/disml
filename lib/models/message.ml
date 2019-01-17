open Core
open Async
include Message_t

let add_reaction msg (emoji:Emoji.t) =
    let e = match emoji.id with
    | Some i -> Printf.sprintf "%s:%d" emoji.name i
    | None -> emoji.name
    in
    Http.create_reaction msg.channel_id msg.id e
    >>| Result.map ~f:ignore

let remove_reaction msg (emoji:Emoji.t) (user:User_t.t) =
    let e = match emoji.id with
    | Some i -> Printf.sprintf "%s:%d" emoji.name i
    | None -> emoji.name
    in
    Http.delete_reaction msg.channel_id msg.id e user.id
    >>| Result.map ~f:ignore

let clear_reactions msg =
    Http.delete_reactions msg.channel_id msg.id
    >>| Result.map ~f:ignore

let delete msg =
    Http.delete_message msg.channel_id msg.id
    >>| Result.map ~f:ignore

let pin msg =
    Http.pin_message msg.channel_id msg.id
    >>| Result.map ~f:ignore

let unpin msg =
    Http.unpin_message msg.channel_id msg.id
    >>| Result.map ~f:ignore

let reply msg cont =
    let rep = `Assoc [("content", `String cont)] in
    Http.create_message msg.channel_id rep
    >>| Result.map ~f:Message_t.of_yojson_exn

let set_content msg cont =
    to_yojson { msg with content = cont; }
    |> Http.edit_message msg.channel_id msg.id
    >>| Result.map ~f:Message_t.of_yojson_exn

let set_embed msg embed =
    to_yojson { msg with embeds = [embed]; }
    |> Http.edit_message msg.channel_id msg.id
    >>| Result.map ~f:Message_t.of_yojson_exn