open Core
open Async

module RouteMap = Map.Make(String)

type rl = {
    limit: int;
    remaining: int;
    reset: int;
}

type t = ((rl, read_write) Mvar.t) RouteMap.t

let rl_of_header h =
    let module C = Cohttp.Header in
    match C.get h "X-RateLimit-Limit", C.get h "X-RateLimit-Remaining", C.get h "X-RateLimit-Reset" with
    | Some lim, Some rem, Some re ->
        let limit = Int.of_string lim in
        let remaining = Int.of_string rem in
        let reset = Int.of_string re in
        Some { limit; remaining; reset; }
    | _ -> None

let update = RouteMap.update
let empty : t = RouteMap.empty
let find = RouteMap.find
let find_exn m s = match find m s with
    | Some r -> r
    | None -> raise (Not_found_s (String.sexp_of_t s))