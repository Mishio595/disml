open Lwt.Infix
open Cohttp
open Cohttp_lwt_unix

module Base = struct
    exception Invalid_Method

    let base_url = "https://discordapp.com/api/v7"
    let cdn_url = "https://cdn.discordapp.com"

    let process_url path =
        Uri.of_string (base_url ^ path)

    let process_request_body body =
        body
        |> Yojson.Basic.to_string
        |> Cohttp_lwt.Body.of_string

    let process_request_headers () =
        let token = try
            Sys.getenv "DISCORD_TOKEN"
        with Not_found -> failwith "Please provide a token" in
        let h = Header.init_with "User-Agent" "Animus v0.1.0" in
        let h = Header.add h "Authorization" ("Bot " ^ token) in
        Header.add h "Content-Type" "application/json"

    (* TODO Finish processor *)
    let process_response (resp, body) =
        body |> Cohttp_lwt.Body.to_string >|= Yojson.Basic.from_string

    let request ?(body=`Null) m path =
        let uri = process_url path in
        let headers = process_request_headers () in
        let body = process_request_body body in
        (match m with
        | `DELETE -> Client.delete ~headers ~body uri
        | `GET -> Client.get ~headers uri
        | `PATCH -> Client.patch ~headers ~body uri
        | `POST -> Client.post ~headers ~body uri
        | `PUT -> Client.put ~headers ~body uri
        | _ -> raise Invalid_Method)
        >|= process_response
end