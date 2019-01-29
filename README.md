# Dis.ml - An OCaml wrapper for the Discord API

This is a library for creating bots on [Discord](https://discordapp.com/). Dis.ml uses JaneStreet's Async and Core libs and I highly recommend having a solid understanding of both of these before using this library.

Docs can be found [here](https://mishio595.gitlab.io/disml).

## State of the project
Latest changes are on master

#### What is implemented?
* The full Discord REST API
* Complete gateway support (sans voice)
* Automatic sharding
* Event dispatch to a user-defined consumer
* Automatic reconnection of dropped gateway connections
* Automatic rate limit handling

#### What is not implemented?
* Abstractions for Discord Objects (Message, Guild, Channel, etc) (**Mostly Completed**)
* Voice
* Cache

## Getting started
In order to get started you'll first need to install OCaml (of course). I recommend using OPAM and Dune as a package manager and build tool respectively.

The project is not currently uploaded to opam. This will happen with the first stable release. If you do not use opam, see `disml.opam` for build instructions.

You'll find an example bot in /bin directory.
