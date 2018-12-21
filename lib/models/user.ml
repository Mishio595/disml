module Make(Http : S.Http) = struct
    open Core
    open User_t
    
    type t = User_t.t

    let tag user =
        Printf.sprintf "%s#%d" user.username user.discriminator

    let mention (user:User_t.t) =
        Printf.sprintf "<@%d>" user.id

    let default_avatar user =
        let avatar = user.discriminator % 5 in
        Endpoints.cdn_default_avatar avatar

    let face user = match user.avatar with
        | Some avatar ->
            let ext = if String.is_substring ~substring:"a_" avatar
            then "gif"
            else "png" in
            Endpoints.cdn_avatar user.id avatar ext
        | None -> default_avatar user
end