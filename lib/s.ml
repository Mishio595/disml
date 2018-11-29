open Async
open Cohttp

module type Token = sig
    val token : string
end

module type Http = sig
    module Base : sig
        exception Invalid_Method

        val base_url : string

        val process_url : string -> Uri.t
        val process_request_body : Yojson.Basic.json -> Cohttp_async.Body.t
        val process_request_headers : unit -> Headers.t

        val process_response :
            Cohttp_async.Response.t * Cohttp_async.Body.t ->
            Yojson.Basic.json

        val request :
            ?body:Yojson.Basic.json ->
            [ `Delete | `Get | `Patch | `Post | `Put ] ->
            string ->
            Yojson.Basic.json Deferred.t
    end

    (* TODO add abstraction sigs *)
    val token : string
end