module Make(Http : S.Http) = struct
    open Async
    open Message_t

    type t = Message_t.t

    let add_reaction msg (emoji:Emoji_t.t) =
        let e = match emoji.id with
        | Some i -> Printf.sprintf "%s:%d" emoji.name i
        | None -> emoji.name
        in
        Http.create_reaction msg.channel_id msg.id e

    let remove_reaction msg (emoji:Emoji_t.t) (user:User_t.t) =
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

    let set_content msg cont =
        Message_j.string_of_t { msg with content = cont; }
        |> Yojson.Safe.from_string
        |> Http.edit_message msg.channel_id msg.id

    let set_embed msg embed =
        Message_j.string_of_t { msg with embeds = [embed]; }
        |> Yojson.Safe.from_string
        |> Http.edit_message msg.channel_id msg.id
end