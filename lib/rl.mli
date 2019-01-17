open Core
open Async

module RouteMap : module type of Map.Make(String)

type rl = {
    limit: int;
    remaining: int;
    reset: int;
}

type t = ((rl, read_write) Mvar.t) RouteMap.t

val rl_of_header : Cohttp.Header.t -> rl option
val default : rl
val empty : t
val update : 'a RouteMap.t -> string -> f:('a option -> 'a) -> 'a RouteMap.t
val find : 'a RouteMap.t -> string -> 'a option
val find_exn : 'a RouteMap.t -> string -> 'a