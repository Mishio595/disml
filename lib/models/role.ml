open Role_t

let wrap { id; role; } =
        let guild_id = id in
        let {id;name;colour;hoist;position;permissions;managed;mentionable} = role in
        {id;name;colour;hoist;position;permissions;managed;mentionable;guild_id}

module Make(Http : S.Http) = struct
    let edit_role ~body role = Http.guild_role_edit role.guild_id role.id body

    let allow_mention role =
        edit_role ~body:(`Assoc [("mentionable", `Bool true)]) role
    
    let delete role = Http.guild_role_remove role.guild_id role.id

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
end