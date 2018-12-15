(* Auto-generated from "role.atd" *)
[@@@ocaml.warning "-27-32-35-39"]

type snowflake = Snowflake_t.t

type t = Role_t.t = {
  id: snowflake;
  name: string;
  colour: int;
  hoist: bool;
  position: int;
  permissions: int;
  managed: bool;
  mentionable: bool
}

let write_snowflake = (
  Snowflake_j.write_t
)
let string_of_snowflake ?(len = 1024) x =
  let ob = Bi_outbuf.create len in
  write_snowflake ob x;
  Bi_outbuf.contents ob
let read_snowflake = (
  Snowflake_j.read_t
)
let snowflake_of_string s =
  read_snowflake (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write_t : _ -> t -> _ = (
  fun ob x ->
    Bi_outbuf.add_char ob '{';
    let is_first = ref true in
    if !is_first then
      is_first := false
    else
      Bi_outbuf.add_char ob ',';
    Bi_outbuf.add_string ob "\"id\":";
    (
      write_snowflake
    )
      ob x.id;
    if !is_first then
      is_first := false
    else
      Bi_outbuf.add_char ob ',';
    Bi_outbuf.add_string ob "\"name\":";
    (
      Yojson.Safe.write_string
    )
      ob x.name;
    if !is_first then
      is_first := false
    else
      Bi_outbuf.add_char ob ',';
    Bi_outbuf.add_string ob "\"color\":";
    (
      Yojson.Safe.write_int
    )
      ob x.colour;
    if !is_first then
      is_first := false
    else
      Bi_outbuf.add_char ob ',';
    Bi_outbuf.add_string ob "\"hoist\":";
    (
      Yojson.Safe.write_bool
    )
      ob x.hoist;
    if !is_first then
      is_first := false
    else
      Bi_outbuf.add_char ob ',';
    Bi_outbuf.add_string ob "\"position\":";
    (
      Yojson.Safe.write_int
    )
      ob x.position;
    if !is_first then
      is_first := false
    else
      Bi_outbuf.add_char ob ',';
    Bi_outbuf.add_string ob "\"permissions\":";
    (
      Yojson.Safe.write_int
    )
      ob x.permissions;
    if !is_first then
      is_first := false
    else
      Bi_outbuf.add_char ob ',';
    Bi_outbuf.add_string ob "\"managed\":";
    (
      Yojson.Safe.write_bool
    )
      ob x.managed;
    if !is_first then
      is_first := false
    else
      Bi_outbuf.add_char ob ',';
    Bi_outbuf.add_string ob "\"mentionable\":";
    (
      Yojson.Safe.write_bool
    )
      ob x.mentionable;
    Bi_outbuf.add_char ob '}';
)
let string_of_t ?(len = 1024) x =
  let ob = Bi_outbuf.create len in
  write_t ob x;
  Bi_outbuf.contents ob
let read_t = (
  fun p lb ->
    Yojson.Safe.read_space p lb;
    Yojson.Safe.read_lcurl p lb;
    let field_id = ref (Obj.magic (Sys.opaque_identity 0.0)) in
    let field_name = ref (Obj.magic (Sys.opaque_identity 0.0)) in
    let field_colour = ref (Obj.magic (Sys.opaque_identity 0.0)) in
    let field_hoist = ref (Obj.magic (Sys.opaque_identity 0.0)) in
    let field_position = ref (Obj.magic (Sys.opaque_identity 0.0)) in
    let field_permissions = ref (Obj.magic (Sys.opaque_identity 0.0)) in
    let field_managed = ref (Obj.magic (Sys.opaque_identity 0.0)) in
    let field_mentionable = ref (Obj.magic (Sys.opaque_identity 0.0)) in
    let bits0 = ref 0 in
    try
      Yojson.Safe.read_space p lb;
      Yojson.Safe.read_object_end lb;
      Yojson.Safe.read_space p lb;
      let f =
        fun s pos len ->
          if pos < 0 || len < 0 || pos + len > String.length s then
            invalid_arg "out-of-bounds substring position or length";
          match len with
            | 2 -> (
                if String.unsafe_get s pos = 'i' && String.unsafe_get s (pos+1) = 'd' then (
                  0
                )
                else (
                  -1
                )
              )
            | 4 -> (
                if String.unsafe_get s pos = 'n' && String.unsafe_get s (pos+1) = 'a' && String.unsafe_get s (pos+2) = 'm' && String.unsafe_get s (pos+3) = 'e' then (
                  1
                )
                else (
                  -1
                )
              )
            | 5 -> (
                match String.unsafe_get s pos with
                  | 'c' -> (
                      if String.unsafe_get s (pos+1) = 'o' && String.unsafe_get s (pos+2) = 'l' && String.unsafe_get s (pos+3) = 'o' && String.unsafe_get s (pos+4) = 'r' then (
                        2
                      )
                      else (
                        -1
                      )
                    )
                  | 'h' -> (
                      if String.unsafe_get s (pos+1) = 'o' && String.unsafe_get s (pos+2) = 'i' && String.unsafe_get s (pos+3) = 's' && String.unsafe_get s (pos+4) = 't' then (
                        3
                      )
                      else (
                        -1
                      )
                    )
                  | _ -> (
                      -1
                    )
              )
            | 7 -> (
                if String.unsafe_get s pos = 'm' && String.unsafe_get s (pos+1) = 'a' && String.unsafe_get s (pos+2) = 'n' && String.unsafe_get s (pos+3) = 'a' && String.unsafe_get s (pos+4) = 'g' && String.unsafe_get s (pos+5) = 'e' && String.unsafe_get s (pos+6) = 'd' then (
                  6
                )
                else (
                  -1
                )
              )
            | 8 -> (
                if String.unsafe_get s pos = 'p' && String.unsafe_get s (pos+1) = 'o' && String.unsafe_get s (pos+2) = 's' && String.unsafe_get s (pos+3) = 'i' && String.unsafe_get s (pos+4) = 't' && String.unsafe_get s (pos+5) = 'i' && String.unsafe_get s (pos+6) = 'o' && String.unsafe_get s (pos+7) = 'n' then (
                  4
                )
                else (
                  -1
                )
              )
            | 11 -> (
                match String.unsafe_get s pos with
                  | 'm' -> (
                      if String.unsafe_get s (pos+1) = 'e' && String.unsafe_get s (pos+2) = 'n' && String.unsafe_get s (pos+3) = 't' && String.unsafe_get s (pos+4) = 'i' && String.unsafe_get s (pos+5) = 'o' && String.unsafe_get s (pos+6) = 'n' && String.unsafe_get s (pos+7) = 'a' && String.unsafe_get s (pos+8) = 'b' && String.unsafe_get s (pos+9) = 'l' && String.unsafe_get s (pos+10) = 'e' then (
                        7
                      )
                      else (
                        -1
                      )
                    )
                  | 'p' -> (
                      if String.unsafe_get s (pos+1) = 'e' && String.unsafe_get s (pos+2) = 'r' && String.unsafe_get s (pos+3) = 'm' && String.unsafe_get s (pos+4) = 'i' && String.unsafe_get s (pos+5) = 's' && String.unsafe_get s (pos+6) = 's' && String.unsafe_get s (pos+7) = 'i' && String.unsafe_get s (pos+8) = 'o' && String.unsafe_get s (pos+9) = 'n' && String.unsafe_get s (pos+10) = 's' then (
                        5
                      )
                      else (
                        -1
                      )
                    )
                  | _ -> (
                      -1
                    )
              )
            | _ -> (
                -1
              )
      in
      let i = Yojson.Safe.map_ident p f lb in
      Atdgen_runtime.Oj_run.read_until_field_value p lb;
      (
        match i with
          | 0 ->
            field_id := (
              (
                read_snowflake
              ) p lb
            );
            bits0 := !bits0 lor 0x1;
          | 1 ->
            field_name := (
              (
                Atdgen_runtime.Oj_run.read_string
              ) p lb
            );
            bits0 := !bits0 lor 0x2;
          | 2 ->
            field_colour := (
              (
                Atdgen_runtime.Oj_run.read_int
              ) p lb
            );
            bits0 := !bits0 lor 0x4;
          | 3 ->
            field_hoist := (
              (
                Atdgen_runtime.Oj_run.read_bool
              ) p lb
            );
            bits0 := !bits0 lor 0x8;
          | 4 ->
            field_position := (
              (
                Atdgen_runtime.Oj_run.read_int
              ) p lb
            );
            bits0 := !bits0 lor 0x10;
          | 5 ->
            field_permissions := (
              (
                Atdgen_runtime.Oj_run.read_int
              ) p lb
            );
            bits0 := !bits0 lor 0x20;
          | 6 ->
            field_managed := (
              (
                Atdgen_runtime.Oj_run.read_bool
              ) p lb
            );
            bits0 := !bits0 lor 0x40;
          | 7 ->
            field_mentionable := (
              (
                Atdgen_runtime.Oj_run.read_bool
              ) p lb
            );
            bits0 := !bits0 lor 0x80;
          | _ -> (
              Yojson.Safe.skip_json p lb
            )
      );
      while true do
        Yojson.Safe.read_space p lb;
        Yojson.Safe.read_object_sep p lb;
        Yojson.Safe.read_space p lb;
        let f =
          fun s pos len ->
            if pos < 0 || len < 0 || pos + len > String.length s then
              invalid_arg "out-of-bounds substring position or length";
            match len with
              | 2 -> (
                  if String.unsafe_get s pos = 'i' && String.unsafe_get s (pos+1) = 'd' then (
                    0
                  )
                  else (
                    -1
                  )
                )
              | 4 -> (
                  if String.unsafe_get s pos = 'n' && String.unsafe_get s (pos+1) = 'a' && String.unsafe_get s (pos+2) = 'm' && String.unsafe_get s (pos+3) = 'e' then (
                    1
                  )
                  else (
                    -1
                  )
                )
              | 5 -> (
                  match String.unsafe_get s pos with
                    | 'c' -> (
                        if String.unsafe_get s (pos+1) = 'o' && String.unsafe_get s (pos+2) = 'l' && String.unsafe_get s (pos+3) = 'o' && String.unsafe_get s (pos+4) = 'r' then (
                          2
                        )
                        else (
                          -1
                        )
                      )
                    | 'h' -> (
                        if String.unsafe_get s (pos+1) = 'o' && String.unsafe_get s (pos+2) = 'i' && String.unsafe_get s (pos+3) = 's' && String.unsafe_get s (pos+4) = 't' then (
                          3
                        )
                        else (
                          -1
                        )
                      )
                    | _ -> (
                        -1
                      )
                )
              | 7 -> (
                  if String.unsafe_get s pos = 'm' && String.unsafe_get s (pos+1) = 'a' && String.unsafe_get s (pos+2) = 'n' && String.unsafe_get s (pos+3) = 'a' && String.unsafe_get s (pos+4) = 'g' && String.unsafe_get s (pos+5) = 'e' && String.unsafe_get s (pos+6) = 'd' then (
                    6
                  )
                  else (
                    -1
                  )
                )
              | 8 -> (
                  if String.unsafe_get s pos = 'p' && String.unsafe_get s (pos+1) = 'o' && String.unsafe_get s (pos+2) = 's' && String.unsafe_get s (pos+3) = 'i' && String.unsafe_get s (pos+4) = 't' && String.unsafe_get s (pos+5) = 'i' && String.unsafe_get s (pos+6) = 'o' && String.unsafe_get s (pos+7) = 'n' then (
                    4
                  )
                  else (
                    -1
                  )
                )
              | 11 -> (
                  match String.unsafe_get s pos with
                    | 'm' -> (
                        if String.unsafe_get s (pos+1) = 'e' && String.unsafe_get s (pos+2) = 'n' && String.unsafe_get s (pos+3) = 't' && String.unsafe_get s (pos+4) = 'i' && String.unsafe_get s (pos+5) = 'o' && String.unsafe_get s (pos+6) = 'n' && String.unsafe_get s (pos+7) = 'a' && String.unsafe_get s (pos+8) = 'b' && String.unsafe_get s (pos+9) = 'l' && String.unsafe_get s (pos+10) = 'e' then (
                          7
                        )
                        else (
                          -1
                        )
                      )
                    | 'p' -> (
                        if String.unsafe_get s (pos+1) = 'e' && String.unsafe_get s (pos+2) = 'r' && String.unsafe_get s (pos+3) = 'm' && String.unsafe_get s (pos+4) = 'i' && String.unsafe_get s (pos+5) = 's' && String.unsafe_get s (pos+6) = 's' && String.unsafe_get s (pos+7) = 'i' && String.unsafe_get s (pos+8) = 'o' && String.unsafe_get s (pos+9) = 'n' && String.unsafe_get s (pos+10) = 's' then (
                          5
                        )
                        else (
                          -1
                        )
                      )
                    | _ -> (
                        -1
                      )
                )
              | _ -> (
                  -1
                )
        in
        let i = Yojson.Safe.map_ident p f lb in
        Atdgen_runtime.Oj_run.read_until_field_value p lb;
        (
          match i with
            | 0 ->
              field_id := (
                (
                  read_snowflake
                ) p lb
              );
              bits0 := !bits0 lor 0x1;
            | 1 ->
              field_name := (
                (
                  Atdgen_runtime.Oj_run.read_string
                ) p lb
              );
              bits0 := !bits0 lor 0x2;
            | 2 ->
              field_colour := (
                (
                  Atdgen_runtime.Oj_run.read_int
                ) p lb
              );
              bits0 := !bits0 lor 0x4;
            | 3 ->
              field_hoist := (
                (
                  Atdgen_runtime.Oj_run.read_bool
                ) p lb
              );
              bits0 := !bits0 lor 0x8;
            | 4 ->
              field_position := (
                (
                  Atdgen_runtime.Oj_run.read_int
                ) p lb
              );
              bits0 := !bits0 lor 0x10;
            | 5 ->
              field_permissions := (
                (
                  Atdgen_runtime.Oj_run.read_int
                ) p lb
              );
              bits0 := !bits0 lor 0x20;
            | 6 ->
              field_managed := (
                (
                  Atdgen_runtime.Oj_run.read_bool
                ) p lb
              );
              bits0 := !bits0 lor 0x40;
            | 7 ->
              field_mentionable := (
                (
                  Atdgen_runtime.Oj_run.read_bool
                ) p lb
              );
              bits0 := !bits0 lor 0x80;
            | _ -> (
                Yojson.Safe.skip_json p lb
              )
        );
      done;
      assert false;
    with Yojson.End_of_object -> (
        if !bits0 <> 0xff then Atdgen_runtime.Oj_run.missing_fields p [| !bits0 |] [| "id"; "name"; "colour"; "hoist"; "position"; "permissions"; "managed"; "mentionable" |];
        (
          {
            id = !field_id;
            name = !field_name;
            colour = !field_colour;
            hoist = !field_hoist;
            position = !field_position;
            permissions = !field_permissions;
            managed = !field_managed;
            mentionable = !field_mentionable;
          }
         : t)
      )
)
let t_of_string s =
  read_t (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
