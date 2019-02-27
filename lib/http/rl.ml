open Core
open Async

module RouteMap = Map.Make(String)

type rl = {
    limit: int;
    remaining: int;
    reset: int;
} [@@deriving sexp]

(* TODO improve route getting, use Date header *)
type t = ((rl, read_write) Mvar.t) RouteMap.t

let r_msg = Tyre.(str "/channel/" *> pos_int <&> str "/messages/" *> pos_int)
let r_message_delete = Tyre.compile r_msg
let r_emoji = Tyre.(compile (r_msg <&> str "/reactions/" *> pcre "[\w\d:]+" <* (str "/@me" <|> str "/" *> pos_int)))

let route_of_path meth path =
    match meth with
    | `Delete -> begin
        match Tyre.exec r_message_delete path with
        | Ok (cid, _) -> Printf.sprintf "/channel/%d/messages" cid
        | Error _ -> path
        end
    | `Put -> begin
        match Tyre.exec r_emoji path with
        | Ok ((cid, mid), _) -> Printf.sprintf "channel/%d/messages/%d/reactions" cid mid
        | Error _ -> path
        end
    | _ -> path    

let rl_of_header h =
    let module C = Cohttp.Header in
    match C.get h "X-RateLimit-Limit", C.get h "X-RateLimit-Remaining", C.get h "X-RateLimit-Reset" with
    | Some lim, Some rem, Some re ->
        let limit = Int.of_string lim in
        let remaining = Int.of_string rem in
        let reset = Int.of_string re in
        Some { limit; remaining; reset; }
    | _ -> None

let default = { limit = 1; remaining = 1; reset = 0; }
let empty : t = RouteMap.empty
let update = RouteMap.update
let find = RouteMap.find
let find_exn m s = match find m s with
    | Some r -> r
    | None -> raise (Not_found_s (String.sexp_of_t s))

let get_rl meth path rl =
    let route = route_of_path meth path in
    match RouteMap.find rl route with
    | Some r -> r, rl
    | None ->
        let data = Mvar.create () in
        Mvar.set data default;
        let rl = RouteMap.add_exn rl ~key:route ~data in
        data, rl