module Make(Http : S.Http) = struct
    let reply (message:Message_t.t) str =
        let msg = `Assoc [
            ("content", `String str)
        ] in
        Http.create_message (string_of_int (message.channel_id)) (msg)
end