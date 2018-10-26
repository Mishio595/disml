open Lwt.Infix
open Websocket

module ShardSet = Set.Make(Shard)

type t = {
    shards: Shard.t ShardSet.t;
    gateway_url: Uri.t;
    token: string;
}

let create_shard ?(options=[]) manager =
    let id = (ShardSet.cardinal manager.shards) + 1 in
    Shard.connect ~options ~uri:manager.gateway_url ~id ~total:(ShardSet.cardinal manager.shards) ~token:manager.token ()
    >|= fun shard ->
    ShardSet.add shard manager.shards

let update_shard shard manager =
    match ShardSet.mem shard manager.shards with
    | true -> ShardSet.add shard manager.shards
    | false -> manager.shards

let heartbeat shard manager =
    Shard.heartbeat shard

let identify shard manager =
    let total = ShardSet.cardinal manager.shards in
    Shard.identify total manager.token shard

let resume shard manager =
    Shard.resume manager.token shard