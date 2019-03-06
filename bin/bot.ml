open Lwt.Infix
open Disml
open Models

module String = Base.String

(* Define a function to handle message_create *)
let check_command (message:Message.t) =
    (* Simple example of command parsing. *)
    let cmd, rest = match String.split ~on:' ' (String.lowercase message.content) with
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
    | "!restart" -> Commands.restart message rest
    | "!rgm" -> Commands.request_members message rest
    | "!new" -> Commands.new_guild message rest
    | "!delall" -> Commands.delete_guilds message rest
    | "!roletest" -> Commands.role_test message rest
    | "!perms" -> Commands.check_permissions message rest
    | _ -> Lwt.return_unit (* Fallback case, no matched command. *)

(* Example Lwt-friendly logs setup *)
let setup_logger () =
    let lwt_reporter () =
        let buf_fmt ~like =
            let b = Buffer.create 512 in
            Fmt.with_buffer ~like b,
            fun () -> let m = Buffer.contents b in Buffer.reset b; m
        in
        let app, app_flush = buf_fmt ~like:Fmt.stdout in
        let dst, dst_flush = buf_fmt ~like:Fmt.stderr in
        let reporter = Logs_fmt.reporter ~app ~dst () in
        let report src level ~over k msgf =
            let k () =
                let write () = match level with
                | Logs.App -> Lwt_io.write Lwt_io.stdout (app_flush ())
                | _ -> Lwt_io.write Lwt_io.stderr (dst_flush ())
                in
                let unblock () = over (); Lwt.return_unit in
                Lwt.async (fun () -> Lwt.finalize write unblock);
                k ()
            in
            reporter.Logs.report src level ~over:(fun () -> ()) k msgf;
        in
        { Logs.report = report }
    in
    Fmt.set_style_renderer Fmt.stdout `Ansi_tty;
    Fmt.set_style_renderer Fmt.stderr `Ansi_tty;
    Logs.set_reporter (lwt_reporter ());
    Logs.set_level (Some Info)

let main () =
    (* Register some event handlers *)
    Client.message_create := check_command;
    Client.ready := (fun ready -> Logs_lwt.app (fun m -> m "Logged in as %s" (User.tag ready.user)));
    Client.guild_create := (fun guild -> Logs_lwt.app (fun m -> m "Joined guild %s" guild.name));
    Client.guild_delete := (fun {id;_} -> let `Guild_id id = id in Logs_lwt.app (fun m -> m "Left guild %d" id));
    (* Pull token from env var. It is not recommended to hardcode your token. *)
    let token = match Stdlib.Sys.getenv_opt "DISCORD_TOKEN" with
    | Some t -> t
    | None -> failwith "No token in env"
    in
    (* Start client. *)
    Client.start ~large:250 token
    (* Fill that ivar once its done *)
    >|= Lwt.wakeup_later Commands.r_client >>= fun _ ->
    fst (Lwt.wait ())
    (* Lwt.join (List.map (fun (t:Gateway.Sharder.Shard.shard Gateway.Sharder.Shard.t) -> fst t.stop) client.sharder.shards) *)

(* Lastly, we have to register this to the Async Scheduler for anything to work *)
let _ =
    setup_logger ();
    Lwt_main.run @@ main ()
