type t = {
    id: int;
    as_string: string;
}

let to_int t = t.id
let to_string t = t.as_string

let from_int i = {
    id = i;
    as_string = string_of_int i;
}
let from_string s = {
    id = int_of_string s;
    as_string = s;
}