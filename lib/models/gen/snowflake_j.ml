(* Auto-generated from "snowflake.atd" *)
[@@@ocaml.warning "-27-32-35-39"]

type t = Snowflake_t.t

let write_t = (
  Yojson.Safe.write_int
)
let string_of_t ?(len = 1024) x =
  let ob = Bi_outbuf.create len in
  write_t ob x;
  Bi_outbuf.contents ob
let read_t = (
  Atdgen_runtime.Oj_run.read_int
)
let t_of_string s =
  read_t (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
