type t = {
    id: string;
    name: string;
}

let from_json term =
    let module J = Yojson.Basic.Util in
    let id = J.(member "id" term |> to_string) in
    let name = J.(member "name" term |> to_string) in
    { id; name; }
