module Make(Http : S.Http) = struct
    open Async
    open Core
    include Channel_t

    exception Invalid_message
    exception No_message_found
    
    let say ~content ch =
        Http.create_message (get_id ch) (`Assoc [("content", `String content)])
        >>| Result.map ~f:Message_t.of_yojson_exn

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
        ]) >>| Result.map ~f:Message_t.of_yojson_exn

    let delete ch =
        Http.delete_channel (get_id ch) >>| Result.map ~f:ignore

    let get_message ~id ch =
        Http.get_message (get_id ch) id >>| Result.map ~f:Message_t.of_yojson_exn

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
            Yojson.Safe.Util.to_list l
            |> List.map ~f:Message_t.of_yojson_exn)

    let broadcast_typing ch =
        Http.broadcast_typing (get_id ch) >>| Result.map ~f:ignore

    let get_pins ch =
        Http.get_pinned_messages (get_id ch) >>| Result.map ~f:(fun l ->
            Yojson.Safe.Util.to_list l
            |> List.map ~f:Message_t.of_yojson_exn)
end