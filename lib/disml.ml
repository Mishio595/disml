(**
    {2 Dis.ml - An OCaml library for interfacing with the Discord API}

    {3 Example}

    {[
open Async
open Core
open Disml
open Models

(* Create a function to handle message_create. *)
let check_command (Event.MessageCreate.{message}) =
    if String.is_prefix ~prefix:"!ping" message.content then
        Message.reply message "Pong!" >>> ignore

let main () =
    (* Register the event handler *)
    Client.message_create := check_command;
    (* Start the client. It's recommended to load the token from an env var or other config file. *)
    Client.start "My token" >>> ignore

let _ =
    (* Launch the Async scheduler. You must do this for anything to work. *)
    Scheduler.go_main ~main ()
    ]}
*)

(** The primary interface for connecting to Discord and handling gateway events. *)
module Client = Client

(** Caching module. {!Cache.cache} is an {{!Async.Mvar.Read_write.t}Mvar}, which is always filled, containing an immutable cache record to allow for safe, concurrent access. *)
module Cache = Cache

(** Raw HTTP abstractions for Discord's REST API. *)
module Http = struct
    include Http

    (** Internal module for resolving endpoints *)
    module Endpoints = Endpoints

    (** Internal module for handling rate limiting *)
    module Ratelimits = Rl
end

(** Gateway connection super module. *)
module Gateway = struct

    (** Internal module used for dispatching events. *)
    module Dispatch = Dispatch

    (** Internal module for representing events. *)
    module Event = Event

    (** Internal module for representing Discord's opcodes. *)
    module Opcode = Opcode

    (** Shard manager *)
    module Sharder = Sharder
end

(** Super module for all Discord object types. *)
module Models = struct

    (** Represents a user's activity. *)
    module Activity = Activity

    (** Represents a message attachment. *)
    module Attachment = Attachment

    (** Represents a ban object. *)
    module Ban = Ban

    (** Represents a full channel object. *)
    module Channel = Channel

    (** Represents solely a channel ID. REST operations can be performed without the full object overhead using this. *)
    module Channel_id = Channel_id

    (** Represents an embed object. *)
    module Embed = Embed

    (** Represents an emoji, both custom and unicode. *)
    module Emoji = Emoji

    (** Represents a guild object, also called a server. *)
    module Guild = Guild

    (** Represents solely a guild ID. REST operations can be performed without the full object overhead using this. *)
    module Guild_id = Guild_id

    (** Represents a user in the context of a guild. *)
    module Member = Member

    (** Represents a message object in any channel. *)
    module Message = Message

    (** Represents solely a message ID. REST operations can be performed without the full object overhead using this. *)
    module Message_id = Message_id

    (** Represents a permission integer as bitmask, allowing for constant set representation. *)
    module Permissions = struct
        include Permissions

        module Overwrite = Overwrites
    end

    (** Represents a user presence. See {!Models.Event.PresenceUpdate}. *)
    module Presence = Presence

    (** Represents an emoji used to react to a message. *)
    module Reaction = Reaction

    (** Represents a role object. *)
    module Role = Role

    (** Represents solely a role ID. REST operations can be performed without the full object overhead using this. *)
    module Role_id = Role_id

    (** Represents a Discord ID. *)
    module Snowflake = Snowflake

    (** Represents a user object. *)
    module User = User

    (** Represents solely a user ID. REST operations can be performed without the full object overhead using this. *)
    module User_id = User_id

    (** Represents the structures received over the gateway. *)
    module Event = Event_models
end
