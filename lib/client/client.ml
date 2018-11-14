let notify t data =
    Yojson.Basic.pretty_print Format.std_formatter @@ `Assoc data;
    print_newline ();
    print_endline t;
    ()