open Async
open Core
open Disml
open Models

(* Define a function to handle message_create *)
let check_command (message:Message.t) =
    (* Simple example of command parsing. *)
    let cmd, rest = match String.split ~on:' ' message.content with
    | hd::tl -> hd, tl
    | [] -> "", []
    in match cmd with
    | "!ping" -> Commands.ping message rest
    | "!spam" -> Commands.spam message rest
    | "!list" -> Commands.list message rest
    | "!embed" -> Commands.embed message rest
    | "!status" -> Commands.status message rest
    | "!echo" -> Commands.echo message rest
    | "!cache" -> Commands.cache message rest
    | "!shutdown" -> Commands.shutdown message rest
    | "!rgm" -> Commands.request_members message rest
    | "!new" -> Commands.new_guild message rest
    | "!delall" -> Commands.delete_guilds message rest
    | "!roletest" -> Commands.role_test message rest
    | _ -> () (* Fallback case, no matched command. *)

(* Example logs setup *)
let setup_logger () =
    Logs.set_reporter (Logs_fmt.reporter ());
    Logs.set_level ~all:true (Some Logs.Debug)

let main () =
    setup_logger ();
    (* Register some event handlers *)
    Client.message_create := check_command;
    Client.ready := (fun ready -> Logs.info (fun m -> m "Logged in as %s" (User.tag ready.user)));
    Client.guild_create := (fun guild -> Logs.info (fun m -> m "Joined guild %s" guild.name));
    Client.guild_delete := (fun {id;_} -> let `Guild_id id = id in Logs.info (fun m -> m "Left guild %d" id));
    (* Pull token from env var. It is not recommended to hardcode your token. *)
    let token = match Sys.getenv "DISCORD_TOKEN" with
    | Some t -> t
    | None -> failwith "No token in env"
    in
    (* Start client. *)
    Client.start ~large:250 ~compress:true token
    (* Fill that ivar once its done *)
    >>> Ivar.fill Commands.client

(* Lastly, we have to register this to the Async Scheduler for anything to work *)
let _ =
    Scheduler.go_main ~main ()
