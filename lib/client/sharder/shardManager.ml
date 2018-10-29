open Lwt.Infix

module ShardSet = Set.Make(struct
    type t = Shard.t
    let compare (s1:t) (s2:t) = Pervasives.compare s1.id s2.id
end)

type t = {
    shards: ShardSet.t;
    gateway_url: Uri.t;
    token: string;
}

let create_shard ?(options=[]) manager =
    let id = (ShardSet.cardinal manager.shards) + 1 in
    Shard.connect ~_options:options ~uri:manager.gateway_url ~id ~total:(ShardSet.cardinal manager.shards) ~token:manager.token ()
    >|= fun shard ->
    ShardSet.add shard manager.shards

let update_shard manager shard =
    match ShardSet.mem shard manager.shards with
    | true -> ShardSet.add shard manager.shards
    | false -> manager.shards

let heartbeat _manager shard =
    Shard.heartbeat shard

let identify _manager shard =
    Shard.identify shard

let resume _manager shard =
    Shard.resume shard