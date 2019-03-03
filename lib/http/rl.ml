module RouteMap = Map.Make(String)

let sexp_of_int = Base.Int.sexp_of_t
let int_of_sexp = Base.Int.t_of_sexp

type rl = {
    limit: int;
    remaining: int;
    reset: int;
} [@@deriving sexp]

(* TODO improve route getting, use Date header *)
type t = rl Lwt_mvar.t RouteMap.t

let r_message_delete = Str.regexp "/channel/[0-9]+/messages/"
let r_emoji = Str.regexp "/channel/[0-9]+/messages/[0-9]+/reactions/[A-Za-z0-9_\\-]+/\\(@me|[0-9]+\\)"

let route_of_path meth path =
    match meth with
    | `Delete -> if Str.string_match r_message_delete path 0 then Str.matched_string path else path
    | `Put -> if Str.string_match r_emoji path 0 then Str.matched_string path else path
    | _ -> path    

let rl_of_header h =
    let module C = Cohttp.Header in
    match C.get h "X-RateLimit-Limit", C.get h "X-RateLimit-Remaining", C.get h "X-RateLimit-Reset" with
    | Some lim, Some rem, Some re ->
        let limit = int_of_string lim in
        let remaining = int_of_string rem in
        let reset = int_of_string re in
        Some { limit; remaining; reset; }
    | _ -> None

let default = { limit = 1; remaining = 1; reset = 0; }
let empty : t = RouteMap.empty
let update = RouteMap.update
let find = RouteMap.find

let get_rl meth path rl =
    let route = route_of_path meth path in
    match RouteMap.find_opt route rl with
    | Some r -> r, rl
    | None ->
        let data = Lwt_mvar.create default in
        let rl = RouteMap.add route data rl in
        data, rl