include Member_t

let add_role ~(role:Role_t.t) member =
    let `Guild_id guild_id = member.guild_id in
    let `User_id user_id = member.user.id in
    let `Role_id role_id = role.id in
    Http.add_member_role guild_id user_id role_id

let remove_role ~(role:Role_t.t) member =
    let `Guild_id guild_id = member.guild_id in
    let `User_id user_id = member.user.id in
    let `Role_id role_id = role.id in
    Http.remove_member_role guild_id user_id role_id

let ban ?(reason="") ?(days=0) member =
    let `Guild_id guild_id = member.guild_id in
    let `User_id user_id = member.user.id in
    Http.guild_ban_add guild_id user_id (`Assoc [
        ("delete-message-days", `Int days);
        ("reason", `String reason);
    ])

let kick ?reason member =
    let `Guild_id guild_id = member.guild_id in
    let `User_id user_id = member.user.id in
    let payload = match reason with
    | Some r -> `Assoc [("reason", `String r)]
    | None -> `Null
    in Http.remove_member guild_id user_id payload

let mute member =
    let `Guild_id guild_id = member.guild_id in
    let `User_id user_id = member.user.id in
    Http.edit_member guild_id user_id (`Assoc [
        ("mute", `Bool true);
    ])

let deafen member =
    let `Guild_id guild_id = member.guild_id in
    let `User_id user_id = member.user.id in
    Http.edit_member guild_id user_id (`Assoc [
        ("deaf", `Bool true);
    ])

let unmute member =
    let `Guild_id guild_id = member.guild_id in
    let `User_id user_id = member.user.id in
    Http.edit_member guild_id user_id (`Assoc [
        ("mute", `Bool false);
    ])

let undeafen member =
    let `Guild_id guild_id = member.guild_id in
    let `User_id user_id = member.user.id in
    Http.edit_member guild_id user_id (`Assoc [
        ("deaf", `Bool false);
    ])
