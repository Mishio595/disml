# Dis.ml - An OCaml library for interfacing with the Discord API

This is a library for creating bots on [Discord](https://discordapp.com/). Dis.ml uses JaneStreet's Async and Core libs and I highly recommend having a solid understanding of both of these before using this library.

Docs can be found [here](https://mishio595.gitlab.io/disml) or generated using odoc and dune with `dune build @doc`

---
## State of the project
#### What is implemented?
* The full Discord REST API (Exposed through `Disml.Http` with abstractions on various models)
* Complete gateway support (sans voice)
* Automatic and manual sharding
* Event dispatch to a user-defined consumer that can be changed at runtime
* Automatic reconnection of dropped gateway connections, using RESUME when possible
* Automatic rate limit handling for REST requests
* Cache

#### What is not implemented?
* Abstractions for Discord Objects (**Mostly Completed**)
* Voice

---
## Getting started
In order to get started you'll first need to install OCaml (of course). I recommend using OPAM and Dune as a package manager and build tool respectively.

As of release 0.2.5 (12 February 2019), disml is published on OPAM and installable by running

```
opam install disml
```
If you would like to use the development version, run
```
opam pin add disml --dev-repo
```
**Note:** The dev repo relies on being pinned to the latest `ppx_deriving_yojson` due to breaking changes in `yojson.1.6.0`. You can pin the package with `opam pin add ppx_deriving_yojson --dev-repo`

If you do not use opam, see `disml.opam` for build instructions.

You'll find an example bot in /bin directory.

---
## Examples

#### Robust example
`/bin/bot.ml` **Note:** I use this for most of my testing involving API compat, so you'll likely see some bizarre commands.

#### Basic example

```ocaml
open Async
open Core
open Disml
open Models

(* Create a function to handle message_create. *)
let check_command (message:Message.t) =
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
```