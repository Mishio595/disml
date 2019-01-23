open Core
open Async
include Message_t

let add_reaction msg (emoji:Emoji.t) =
    let e = match emoji.id with
    | Some i -> Printf.sprintf "%s:%d" emoji.name i
    | None -> emoji.name
    in
    Http.create_reaction msg.channel_id msg.id e
   

let remove_reaction msg (emoji:Emoji.t) (user:User_t.t) =
    let e = match emoji.id with
    | Some i -> Printf.sprintf "%s:%d" emoji.name i
    | None -> emoji.name
    in
    Http.delete_reaction msg.channel_id msg.id e user.id
   

let clear_reactions msg =
    Http.delete_reactions msg.channel_id msg.id
   

let delete msg =
    Http.delete_message msg.channel_id msg.id
   

let pin msg =
    Http.pin_message msg.channel_id msg.id
   

let unpin msg =
    Http.unpin_message msg.channel_id msg.id
   

let reply msg cont =
    let rep = `Assoc [("content", `String cont)] in
    Http.create_message msg.channel_id rep
   

let reply_with ?embed ?content ?file ?(tts=false) msg =
    let embed = match embed with
    | Some e -> Embed.to_yojson e
    | None -> `Null in
    let content = match content with
    | Some c -> `String c
    | None -> `Null in
    let file = match file with
    | Some f -> `String f
    | None -> `Null in
    let () = match embed, content with
    | `Null, `Null -> raise Channel.Invalid_message
    | _ -> () in
    Http.create_message (msg.channel_id) (`Assoc [
        ("embed", embed);
        ("content", content);
        ("file", file);
        ("tts", `Bool tts);
    ])

let set_content msg cont =
    to_yojson { msg with content = cont; }
    |> Http.edit_message msg.channel_id msg.id
   

let set_embed msg embed =
    to_yojson { msg with embeds = [embed]; }
    |> Http.edit_message msg.channel_id msg.id
   