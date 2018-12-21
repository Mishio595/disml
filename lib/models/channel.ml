exception Invalid_message
exception No_message_found

let get_id (ch:Channel_t.t) = match ch with
| `Group g -> g.id
| `Private p -> p.id
| `GuildText t -> t.id
| `GuildVoice v -> v.id
| `Category c -> c.id

module Make(Http : S.Http) = struct
    open Async
    open Core

    type t = Channel_t.t

    let say ~content ch =
        Http.create_message (get_id ch) (`Assoc [("content", `String content)])
        >>| Result.map ~f:Message_j.t_of_string

    let send_message ?embed ?content ?file ?(tts=false) ch =
        let embed = match embed with
        | Some e -> e
        | None -> `Null in
        let content = match content with
        | Some c -> `String c
        | None -> `Null in
        let file = match file with
        | Some f -> `String f
        | None -> `Null in
        let () = match embed, content with
        | `Null, `Null -> raise Invalid_message
        | _ -> () in
        Http.create_message (get_id ch) (`Assoc [
            ("embed", embed);
            ("content", content);
            ("file", file);
            ("tts", `Bool tts);
        ]) >>| Result.map ~f:Message_j.t_of_string

    let delete ch =
        Http.delete_channel (get_id ch) >>| Result.map ~f:ignore

    let get_message ~id ch =
        Http.get_message (get_id ch) id >>| Result.map ~f:Message_j.t_of_string

    let get_messages ?(mode=`Around) ?id ?(limit=50) ch =
        let kind = match mode with
        | `Around -> "around", limit
        | `Before -> "before", limit
        | `After -> "after", limit
        in
        let id = match id with
        | Some id -> id
        | None -> raise No_message_found in
        Http.get_messages (get_id ch) id kind >>| Result.map ~f:(fun l ->
            Yojson.Safe.(from_string l
            |> Util.to_list)
            |> List.map ~f:(fun i ->
                Yojson.Safe.to_string i
                |> Message_j.t_of_string))
    
    let broadcast_typing ch =
        Http.broadcast_typing (get_id ch) >>| Result.map ~f:ignore

    let get_pins ch =
        Http.get_pinned_messages (get_id ch) >>| Result.map ~f:(fun l ->
            Yojson.Safe.(from_string l
            |> Util.to_list)
            |> List.map ~f:(fun i ->
                Yojson.Safe.to_string i
                |> Message_j.t_of_string))
end