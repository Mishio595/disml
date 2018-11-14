let notify t data =
    Yojson.Basic.pretty_print Format.std_formatter data;
    print_newline ();
    print_endline t;
    ()