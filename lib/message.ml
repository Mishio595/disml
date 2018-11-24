type t = {
    id: string;
    content: string;
    channel: string;
}

let from_json term =
    let module J = Yojson.Basic.Util in
    let id = J.(member "id" term |> to_string) in
    let content = J.(member "content" term |> to_string) in
    let channel = J.(member "channel_id" term |> to_string) in
    { id; content; channel; }
