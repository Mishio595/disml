type t = {
    user: User.t;
    roles: Role.t list;
    game: Activity.t option;
    guild: Guild.t;
    status: string;
    activities: Activity.t list;
}