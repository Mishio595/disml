open Core
include User_t

let tag user =
    Printf.sprintf "%s#%s" user.username user.discriminator

let mention user =
    let `User_id id = user.id in
    Printf.sprintf "<@%d>" id

let default_avatar user =
    let avatar = Int.of_string user.discriminator % 5 in
    Endpoints.cdn_default_avatar avatar

let face user =
    let `User_id id = user.id in
    match user.avatar with
    | Some avatar ->
        let ext = if String.is_substring ~substring:"a_" avatar
        then "gif"
        else "png" in
        Endpoints.cdn_avatar id avatar ext
    | None -> default_avatar user