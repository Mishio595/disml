type t = {
    id: int;
    username: string;
    discriminator: string;
    avatar: string option;
    bot: bool;
}

let from_json term =
    let module J = Yojson.Basic.Util in
    let id = J.member "id" term
        |> J.to_string
        |> int_of_string
    in
    let username = J.member "username" term
        |> J.to_string in
    let discriminator = J.member "discriminator" term
        |> J.to_string in
    let avatar = J.member "avatar" term
        |> J.to_string_option in
    let bot = J.member "bot" term
        |> J.to_bool in
    { id; username; discriminator; avatar; bot; }

let tag user =
    user.username ^ user.discriminator
