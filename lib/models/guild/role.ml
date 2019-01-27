include Role_t

let edit_role ~body (role:t) =
    let `Role_id id = role.id in
    let `Guild_id guild_id = role.guild_id in
    Http.guild_role_edit guild_id id body

let allow_mention role =
    edit_role ~body:(`Assoc [("mentionable", `Bool true)]) role

let delete (role:t) =
    let `Role_id id = role.id in
    let `Guild_id guild_id = role.guild_id in
    Http.guild_role_remove guild_id id

let disallow_mention role =
    edit_role ~body:(`Assoc [("mentionable", `Bool false)]) role

let hoist role =
    edit_role ~body:(`Assoc [("hoist", `Bool true)]) role

let set_colour ~colour role =
    edit_role ~body:(`Assoc [("color", `Int colour)]) role

let set_name ~name role =
    edit_role ~body:(`Assoc [("name", `String name)]) role

let unhoist role =
    edit_role ~body:(`Assoc [("hoist", `Bool false)]) role