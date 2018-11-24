module type Model = sig
    type t
    val from_json : Yojson.Basic.json -> t
end