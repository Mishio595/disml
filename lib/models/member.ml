type t = {
    user: User.t;
    nick: string option;
    roles: Role.t list;
    joined_at: string;
    deaf: bool;
    mute: bool;
}