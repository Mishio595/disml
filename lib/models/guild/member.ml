include Member_t

let add_role ~(role:Role_t.t) member =
    Http.add_member_role member.guild_id member.user.id role.id

let remove_role ~(role:Role_t.t) member =
    Http.remove_member_role member.guild_id member.user.id role.id

let ban ?(reason="") ?(days=0) member =
    Http.guild_ban_add member.guild_id member.user.id (`Assoc [
        ("delete-message-days", `Int days);
        ("reason", `String reason);
    ])

let kick ?reason member =
    let payload = match reason with
    | Some r -> `Assoc [("reason", `String r)]
    | None -> `Null
    in Http.remove_member member.guild_id member.user.id payload

let mute member =
    Http.edit_member member.guild_id member.user.id (`Assoc [
        ("mute", `Bool true);
    ])

let deafen member =
    Http.edit_member member.guild_id member.user.id (`Assoc [
        ("deaf", `Bool true);
    ])

let unmute member =
    Http.edit_member member.guild_id member.user.id (`Assoc [
        ("mute", `Bool false);
    ])

let undeafen member =
    Http.edit_member member.guild_id member.user.id (`Assoc [
        ("deaf", `Bool false);
    ])
