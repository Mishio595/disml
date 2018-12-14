# Dis.ml - An OCaml wrapper for the Discord API

This is a library for creating bots on [Discord](https://discordapp.com/). Dis.ml uses JaneStreet's Async and Core libs and I highly recommend having a solid understanding of both of these before using this library.

## State of the project
This is being actively developed and is definitely still in the early stages. While you definitely could create a bot with this in its current state, you would be writing a lot of boilerplate still.

#### What is implemented?
* The full Discord REST API
* Rudimentary gateway support
* Automatic sharding
* Event dispatch to a user-defined consumer
* Automatic reconnection of dropped gateway connections
* Automatic rate limit handling

#### What is not implemented?
* Abstractions for Discord Objects (Message, Guild, Channel, etc) (**IN PROGRESS!**)
* Voice
* Cache

## Getting started
In order to get started you'll first need to install OCaml (of course). I recommend using OPAM and Dune as a package manage and build tool respectively.

I currently don't provide an opam build file nor is the project uploaded to opam. This will happen with the first stable release.

You'll find an example bot in /bin directory.
