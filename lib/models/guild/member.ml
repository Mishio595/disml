open Async
open Core
include Member_t

let add_role ~(role:Role_t.t) member =
    Http.add_member_role member.guild_id member.user.id role.id
    >>| Result.map ~f:ignore

let remove_role ~(role:Role_t.t) member =
    Http.remove_member_role member.guild_id member.user.id role.id
    >>| Result.map ~f:ignore

let ban ?(reason="") ?(days=0) member =
    Http.guild_ban_add member.guild_id member.user.id (`Assoc [
        ("delete-message-days", `Int days);
        ("reason", `String reason);
    ]) >>| Result.map ~f:ignore

let kick ?reason member =
    let payload = match reason with
    | Some r -> `Assoc [("reason", `String r)]
    | None -> `Null
    in Http.remove_member member.guild_id member.user.id payload >>| Result.map ~f:ignore

let mute member =
    Http.edit_member member.guild_id member.user.id (`Assoc [
        ("mute", `Bool true);
    ]) >>| Result.map ~f:ignore

let deafen member =
    Http.edit_member member.guild_id member.user.id (`Assoc [
        ("deaf", `Bool true);
    ]) >>| Result.map ~f:ignore

let unmute member =
    Http.edit_member member.guild_id member.user.id (`Assoc [
        ("mute", `Bool false);
    ]) >>| Result.map ~f:ignore

let undeafen member =
    Http.edit_member member.guild_id member.user.id (`Assoc [
        ("deaf", `Bool false);
    ]) >>| Result.map ~f:ignore
