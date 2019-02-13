open Async

include module type of Dispatch

(** Type of the Client, it isn't recommended to access the fields directly. *)
type t =
{ sharder: Sharder.t
}

(** Start the Client. This begins shard connections to Discord and event handlers should be registered prior to calling this.
    {3 Example}
    {[
        open Async
        open Disml

        let main () =
            let token = "a valid bot token" in
            Client.start ~count:5 token >>> print_endline "Client launched"

        let _ =
            Scheduler.go_main ~main ()
    ]}
    @param ?count Optional amount of shards to launch. Defaults to autosharding.
    @param ?compress Whether to use compression over the gateway. }
    @param ?large Large threshold for guilds. Default is 250.
    @param string The token used for authentication.
    @return A deferred client object.
*)
val start :
    ?count:int ->
    ?compress:bool ->
    ?large:int ->
    string ->
    t Deferred.t

(** Same as {!Sharder.set_status} where [client.sharder] is passed. *)
val set_status :
    ?status:string ->
    ?kind:int ->
    ?name:string ->
    ?since:int ->
    t ->
    Sharder.Shard.shard list Deferred.t

(** Same as {!Sharder.request_guild_members} where [client.sharder] is passed. *)
val request_guild_members :
    guild:Guild_id.t ->
    ?query:string ->
    ?limit:int ->
    t ->
    Sharder.Shard.shard list Deferred.t

(** Same as {!Sharder.shutdown_all} where [client.sharder] is passed. *)
val shutdown_all :
    ?restart:bool ->
    t ->
    unit list Deferred.t