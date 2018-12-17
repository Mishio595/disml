(* Auto-generated from "guild.atd" *)
[@@@ocaml.warning "-27-32-35-39"]

type user = User_t.t

type snowflake = Snowflake_t.t

type role = Role_t.t

type member = Member_t.t

type emoji = Emoji_t.t

type channel = Channel_t.t

type t = Guild_t.t = {
  id: snowflake;
  name: string;
  icon: string option;
  splash: string option;
  owner_id: snowflake;
  region: string;
  afk_channel_id: snowflake option;
  afk_timeout: int;
  embed_enabled: bool option;
  embed_channel_id: snowflake option;
  verification_level: int;
  default_message_notifications: int;
  explicit_content_filter: int;
  roles: role list;
  emojis: emoji list;
  features: string list;
  mfa_level: int;
  application_id: snowflake option;
  widget_enabled: bool option;
  widget_channel: channel option;
  system_channel: channel option;
  large: bool option;
  unavailable: bool option;
  member_count: int option;
  members: member list;
  channels: channel list
}

let write_user = (
  User_j.write_t
)
let string_of_user ?(len = 1024) x =
  let ob = Bi_outbuf.create len in
  write_user ob x;
  Bi_outbuf.contents ob
let read_user = (
  User_j.read_t
)
let user_of_string s =
  read_user (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
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
let write_role = (
  Role_j.write_t
)
let string_of_role ?(len = 1024) x =
  let ob = Bi_outbuf.create len in
  write_role ob x;
  Bi_outbuf.contents ob
let read_role = (
  Role_j.read_t
)
let role_of_string s =
  read_role (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write_member = (
  Member_j.write_t
)
let string_of_member ?(len = 1024) x =
  let ob = Bi_outbuf.create len in
  write_member ob x;
  Bi_outbuf.contents ob
let read_member = (
  Member_j.read_t
)
let member_of_string s =
  read_member (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write_emoji = (
  Emoji_j.write_t
)
let string_of_emoji ?(len = 1024) x =
  let ob = Bi_outbuf.create len in
  write_emoji ob x;
  Bi_outbuf.contents ob
let read_emoji = (
  Emoji_j.read_t
)
let emoji_of_string s =
  read_emoji (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write_channel = (
  Channel_j.write_t
)
let string_of_channel ?(len = 1024) x =
  let ob = Bi_outbuf.create len in
  write_channel ob x;
  Bi_outbuf.contents ob
let read_channel = (
  Channel_j.read_t
)
let channel_of_string s =
  read_channel (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write__9 = (
  Atdgen_runtime.Oj_run.write_list (
    write_member
  )
)
let string_of__9 ?(len = 1024) x =
  let ob = Bi_outbuf.create len in
  write__9 ob x;
  Bi_outbuf.contents ob
let read__9 = (
  Atdgen_runtime.Oj_run.read_list (
    read_member
  )
)
let _9_of_string s =
  read__9 (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write__8 = (
  Atdgen_runtime.Oj_run.write_option (
    Yojson.Safe.write_int
  )
)
let string_of__8 ?(len = 1024) x =
  let ob = Bi_outbuf.create len in
  write__8 ob x;
  Bi_outbuf.contents ob
let read__8 = (
  fun p lb ->
    Yojson.Safe.read_space p lb;
    match Yojson.Safe.start_any_variant p lb with
      | `Edgy_bracket -> (
          match Yojson.Safe.read_ident p lb with
            | "None" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              (None : _ option)
            | "Some" ->
              Atdgen_runtime.Oj_run.read_until_field_value p lb;
              let x = (
                  Atdgen_runtime.Oj_run.read_int
                ) p lb
              in
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              (Some x : _ option)
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
      | `Double_quote -> (
          match Yojson.Safe.finish_string p lb with
            | "None" ->
              (None : _ option)
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
      | `Square_bracket -> (
          match Atdgen_runtime.Oj_run.read_string p lb with
            | "Some" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_comma p lb;
              Yojson.Safe.read_space p lb;
              let x = (
                  Atdgen_runtime.Oj_run.read_int
                ) p lb
              in
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_rbr p lb;
              (Some x : _ option)
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
)
let _8_of_string s =
  read__8 (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write__7 = (
  Atdgen_runtime.Oj_run.write_option (
    write_channel
  )
)
let string_of__7 ?(len = 1024) x =
  let ob = Bi_outbuf.create len in
  write__7 ob x;
  Bi_outbuf.contents ob
let read__7 = (
  fun p lb ->
    Yojson.Safe.read_space p lb;
    match Yojson.Safe.start_any_variant p lb with
      | `Edgy_bracket -> (
          match Yojson.Safe.read_ident p lb with
            | "None" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              (None : _ option)
            | "Some" ->
              Atdgen_runtime.Oj_run.read_until_field_value p lb;
              let x = (
                  read_channel
                ) p lb
              in
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              (Some x : _ option)
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
      | `Double_quote -> (
          match Yojson.Safe.finish_string p lb with
            | "None" ->
              (None : _ option)
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
      | `Square_bracket -> (
          match Atdgen_runtime.Oj_run.read_string p lb with
            | "Some" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_comma p lb;
              Yojson.Safe.read_space p lb;
              let x = (
                  read_channel
                ) p lb
              in
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_rbr p lb;
              (Some x : _ option)
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
)
let _7_of_string s =
  read__7 (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write__6 = (
  Atdgen_runtime.Oj_run.write_list (
    Yojson.Safe.write_string
  )
)
let string_of__6 ?(len = 1024) x =
  let ob = Bi_outbuf.create len in
  write__6 ob x;
  Bi_outbuf.contents ob
let read__6 = (
  Atdgen_runtime.Oj_run.read_list (
    Atdgen_runtime.Oj_run.read_string
  )
)
let _6_of_string s =
  read__6 (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write__5 = (
  Atdgen_runtime.Oj_run.write_list (
    write_emoji
  )
)
let string_of__5 ?(len = 1024) x =
  let ob = Bi_outbuf.create len in
  write__5 ob x;
  Bi_outbuf.contents ob
let read__5 = (
  Atdgen_runtime.Oj_run.read_list (
    read_emoji
  )
)
let _5_of_string s =
  read__5 (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write__4 = (
  Atdgen_runtime.Oj_run.write_list (
    write_role
  )
)
let string_of__4 ?(len = 1024) x =
  let ob = Bi_outbuf.create len in
  write__4 ob x;
  Bi_outbuf.contents ob
let read__4 = (
  Atdgen_runtime.Oj_run.read_list (
    read_role
  )
)
let _4_of_string s =
  read__4 (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write__3 = (
  Atdgen_runtime.Oj_run.write_option (
    Yojson.Safe.write_bool
  )
)
let string_of__3 ?(len = 1024) x =
  let ob = Bi_outbuf.create len in
  write__3 ob x;
  Bi_outbuf.contents ob
let read__3 = (
  fun p lb ->
    Yojson.Safe.read_space p lb;
    match Yojson.Safe.start_any_variant p lb with
      | `Edgy_bracket -> (
          match Yojson.Safe.read_ident p lb with
            | "None" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              (None : _ option)
            | "Some" ->
              Atdgen_runtime.Oj_run.read_until_field_value p lb;
              let x = (
                  Atdgen_runtime.Oj_run.read_bool
                ) p lb
              in
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              (Some x : _ option)
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
      | `Double_quote -> (
          match Yojson.Safe.finish_string p lb with
            | "None" ->
              (None : _ option)
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
      | `Square_bracket -> (
          match Atdgen_runtime.Oj_run.read_string p lb with
            | "Some" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_comma p lb;
              Yojson.Safe.read_space p lb;
              let x = (
                  Atdgen_runtime.Oj_run.read_bool
                ) p lb
              in
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_rbr p lb;
              (Some x : _ option)
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
)
let _3_of_string s =
  read__3 (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write__2 = (
  Atdgen_runtime.Oj_run.write_option (
    write_snowflake
  )
)
let string_of__2 ?(len = 1024) x =
  let ob = Bi_outbuf.create len in
  write__2 ob x;
  Bi_outbuf.contents ob
let read__2 = (
  fun p lb ->
    Yojson.Safe.read_space p lb;
    match Yojson.Safe.start_any_variant p lb with
      | `Edgy_bracket -> (
          match Yojson.Safe.read_ident p lb with
            | "None" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              (None : _ option)
            | "Some" ->
              Atdgen_runtime.Oj_run.read_until_field_value p lb;
              let x = (
                  read_snowflake
                ) p lb
              in
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              (Some x : _ option)
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
      | `Double_quote -> (
          match Yojson.Safe.finish_string p lb with
            | "None" ->
              (None : _ option)
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
      | `Square_bracket -> (
          match Atdgen_runtime.Oj_run.read_string p lb with
            | "Some" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_comma p lb;
              Yojson.Safe.read_space p lb;
              let x = (
                  read_snowflake
                ) p lb
              in
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_rbr p lb;
              (Some x : _ option)
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
)
let _2_of_string s =
  read__2 (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write__10 = (
  Atdgen_runtime.Oj_run.write_list (
    write_channel
  )
)
let string_of__10 ?(len = 1024) x =
  let ob = Bi_outbuf.create len in
  write__10 ob x;
  Bi_outbuf.contents ob
let read__10 = (
  Atdgen_runtime.Oj_run.read_list (
    read_channel
  )
)
let _10_of_string s =
  read__10 (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write__1 = (
  Atdgen_runtime.Oj_run.write_option (
    Yojson.Safe.write_string
  )
)
let string_of__1 ?(len = 1024) x =
  let ob = Bi_outbuf.create len in
  write__1 ob x;
  Bi_outbuf.contents ob
let read__1 = (
  fun p lb ->
    Yojson.Safe.read_space p lb;
    match Yojson.Safe.start_any_variant p lb with
      | `Edgy_bracket -> (
          match Yojson.Safe.read_ident p lb with
            | "None" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              (None : _ option)
            | "Some" ->
              Atdgen_runtime.Oj_run.read_until_field_value p lb;
              let x = (
                  Atdgen_runtime.Oj_run.read_string
                ) p lb
              in
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_gt p lb;
              (Some x : _ option)
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
      | `Double_quote -> (
          match Yojson.Safe.finish_string p lb with
            | "None" ->
              (None : _ option)
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
      | `Square_bracket -> (
          match Atdgen_runtime.Oj_run.read_string p lb with
            | "Some" ->
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_comma p lb;
              Yojson.Safe.read_space p lb;
              let x = (
                  Atdgen_runtime.Oj_run.read_string
                ) p lb
              in
              Yojson.Safe.read_space p lb;
              Yojson.Safe.read_rbr p lb;
              (Some x : _ option)
            | x ->
              Atdgen_runtime.Oj_run.invalid_variant_tag p x
        )
)
let _1_of_string s =
  read__1 (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
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
    (match x.icon with None -> () | Some x ->
      if !is_first then
        is_first := false
      else
        Bi_outbuf.add_char ob ',';
      Bi_outbuf.add_string ob "\"icon\":";
      (
        Yojson.Safe.write_string
      )
        ob x;
    );
    (match x.splash with None -> () | Some x ->
      if !is_first then
        is_first := false
      else
        Bi_outbuf.add_char ob ',';
      Bi_outbuf.add_string ob "\"splash\":";
      (
        Yojson.Safe.write_string
      )
        ob x;
    );
    if !is_first then
      is_first := false
    else
      Bi_outbuf.add_char ob ',';
    Bi_outbuf.add_string ob "\"owner_id\":";
    (
      write_snowflake
    )
      ob x.owner_id;
    if !is_first then
      is_first := false
    else
      Bi_outbuf.add_char ob ',';
    Bi_outbuf.add_string ob "\"region\":";
    (
      Yojson.Safe.write_string
    )
      ob x.region;
    (match x.afk_channel_id with None -> () | Some x ->
      if !is_first then
        is_first := false
      else
        Bi_outbuf.add_char ob ',';
      Bi_outbuf.add_string ob "\"afk_channel_id\":";
      (
        write_snowflake
      )
        ob x;
    );
    if !is_first then
      is_first := false
    else
      Bi_outbuf.add_char ob ',';
    Bi_outbuf.add_string ob "\"afk_timeout\":";
    (
      Yojson.Safe.write_int
    )
      ob x.afk_timeout;
    (match x.embed_enabled with None -> () | Some x ->
      if !is_first then
        is_first := false
      else
        Bi_outbuf.add_char ob ',';
      Bi_outbuf.add_string ob "\"embed_enabled\":";
      (
        Yojson.Safe.write_bool
      )
        ob x;
    );
    (match x.embed_channel_id with None -> () | Some x ->
      if !is_first then
        is_first := false
      else
        Bi_outbuf.add_char ob ',';
      Bi_outbuf.add_string ob "\"embed_channel_id\":";
      (
        write_snowflake
      )
        ob x;
    );
    if !is_first then
      is_first := false
    else
      Bi_outbuf.add_char ob ',';
    Bi_outbuf.add_string ob "\"verification_level\":";
    (
      Yojson.Safe.write_int
    )
      ob x.verification_level;
    if !is_first then
      is_first := false
    else
      Bi_outbuf.add_char ob ',';
    Bi_outbuf.add_string ob "\"default_message_notifications\":";
    (
      Yojson.Safe.write_int
    )
      ob x.default_message_notifications;
    if !is_first then
      is_first := false
    else
      Bi_outbuf.add_char ob ',';
    Bi_outbuf.add_string ob "\"explicit_content_filter\":";
    (
      Yojson.Safe.write_int
    )
      ob x.explicit_content_filter;
    if !is_first then
      is_first := false
    else
      Bi_outbuf.add_char ob ',';
    Bi_outbuf.add_string ob "\"roles\":";
    (
      write__4
    )
      ob x.roles;
    if !is_first then
      is_first := false
    else
      Bi_outbuf.add_char ob ',';
    Bi_outbuf.add_string ob "\"emojis\":";
    (
      write__5
    )
      ob x.emojis;
    if !is_first then
      is_first := false
    else
      Bi_outbuf.add_char ob ',';
    Bi_outbuf.add_string ob "\"features\":";
    (
      write__6
    )
      ob x.features;
    if !is_first then
      is_first := false
    else
      Bi_outbuf.add_char ob ',';
    Bi_outbuf.add_string ob "\"mfa_level\":";
    (
      Yojson.Safe.write_int
    )
      ob x.mfa_level;
    (match x.application_id with None -> () | Some x ->
      if !is_first then
        is_first := false
      else
        Bi_outbuf.add_char ob ',';
      Bi_outbuf.add_string ob "\"application_id\":";
      (
        write_snowflake
      )
        ob x;
    );
    (match x.widget_enabled with None -> () | Some x ->
      if !is_first then
        is_first := false
      else
        Bi_outbuf.add_char ob ',';
      Bi_outbuf.add_string ob "\"widget_enabled\":";
      (
        Yojson.Safe.write_bool
      )
        ob x;
    );
    (match x.widget_channel with None -> () | Some x ->
      if !is_first then
        is_first := false
      else
        Bi_outbuf.add_char ob ',';
      Bi_outbuf.add_string ob "\"widget_channel\":";
      (
        write_channel
      )
        ob x;
    );
    (match x.system_channel with None -> () | Some x ->
      if !is_first then
        is_first := false
      else
        Bi_outbuf.add_char ob ',';
      Bi_outbuf.add_string ob "\"system_channel\":";
      (
        write_channel
      )
        ob x;
    );
    (match x.large with None -> () | Some x ->
      if !is_first then
        is_first := false
      else
        Bi_outbuf.add_char ob ',';
      Bi_outbuf.add_string ob "\"large\":";
      (
        Yojson.Safe.write_bool
      )
        ob x;
    );
    (match x.unavailable with None -> () | Some x ->
      if !is_first then
        is_first := false
      else
        Bi_outbuf.add_char ob ',';
      Bi_outbuf.add_string ob "\"unavailable\":";
      (
        Yojson.Safe.write_bool
      )
        ob x;
    );
    (match x.member_count with None -> () | Some x ->
      if !is_first then
        is_first := false
      else
        Bi_outbuf.add_char ob ',';
      Bi_outbuf.add_string ob "\"member_count\":";
      (
        Yojson.Safe.write_int
      )
        ob x;
    );
    if x.members <> [] then (
      if !is_first then
        is_first := false
      else
        Bi_outbuf.add_char ob ',';
      Bi_outbuf.add_string ob "\"members\":";
      (
        write__9
      )
        ob x.members;
    );
    if x.channels <> [] then (
      if !is_first then
        is_first := false
      else
        Bi_outbuf.add_char ob ',';
      Bi_outbuf.add_string ob "\"channels\":";
      (
        write__10
      )
        ob x.channels;
    );
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
    let field_icon = ref (None) in
    let field_splash = ref (None) in
    let field_owner_id = ref (Obj.magic (Sys.opaque_identity 0.0)) in
    let field_region = ref (Obj.magic (Sys.opaque_identity 0.0)) in
    let field_afk_channel_id = ref (None) in
    let field_afk_timeout = ref (Obj.magic (Sys.opaque_identity 0.0)) in
    let field_embed_enabled = ref (None) in
    let field_embed_channel_id = ref (None) in
    let field_verification_level = ref (Obj.magic (Sys.opaque_identity 0.0)) in
    let field_default_message_notifications = ref (Obj.magic (Sys.opaque_identity 0.0)) in
    let field_explicit_content_filter = ref (Obj.magic (Sys.opaque_identity 0.0)) in
    let field_roles = ref (Obj.magic (Sys.opaque_identity 0.0)) in
    let field_emojis = ref (Obj.magic (Sys.opaque_identity 0.0)) in
    let field_features = ref (Obj.magic (Sys.opaque_identity 0.0)) in
    let field_mfa_level = ref (Obj.magic (Sys.opaque_identity 0.0)) in
    let field_application_id = ref (None) in
    let field_widget_enabled = ref (None) in
    let field_widget_channel = ref (None) in
    let field_system_channel = ref (None) in
    let field_large = ref (None) in
    let field_unavailable = ref (None) in
    let field_member_count = ref (None) in
    let field_members = ref ([]) in
    let field_channels = ref ([]) in
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
                match String.unsafe_get s pos with
                  | 'i' -> (
                      if String.unsafe_get s (pos+1) = 'c' && String.unsafe_get s (pos+2) = 'o' && String.unsafe_get s (pos+3) = 'n' then (
                        2
                      )
                      else (
                        -1
                      )
                    )
                  | 'n' -> (
                      if String.unsafe_get s (pos+1) = 'a' && String.unsafe_get s (pos+2) = 'm' && String.unsafe_get s (pos+3) = 'e' then (
                        1
                      )
                      else (
                        -1
                      )
                    )
                  | _ -> (
                      -1
                    )
              )
            | 5 -> (
                match String.unsafe_get s pos with
                  | 'l' -> (
                      if String.unsafe_get s (pos+1) = 'a' && String.unsafe_get s (pos+2) = 'r' && String.unsafe_get s (pos+3) = 'g' && String.unsafe_get s (pos+4) = 'e' then (
                        21
                      )
                      else (
                        -1
                      )
                    )
                  | 'r' -> (
                      if String.unsafe_get s (pos+1) = 'o' && String.unsafe_get s (pos+2) = 'l' && String.unsafe_get s (pos+3) = 'e' && String.unsafe_get s (pos+4) = 's' then (
                        13
                      )
                      else (
                        -1
                      )
                    )
                  | _ -> (
                      -1
                    )
              )
            | 6 -> (
                match String.unsafe_get s pos with
                  | 'e' -> (
                      if String.unsafe_get s (pos+1) = 'm' && String.unsafe_get s (pos+2) = 'o' && String.unsafe_get s (pos+3) = 'j' && String.unsafe_get s (pos+4) = 'i' && String.unsafe_get s (pos+5) = 's' then (
                        14
                      )
                      else (
                        -1
                      )
                    )
                  | 'r' -> (
                      if String.unsafe_get s (pos+1) = 'e' && String.unsafe_get s (pos+2) = 'g' && String.unsafe_get s (pos+3) = 'i' && String.unsafe_get s (pos+4) = 'o' && String.unsafe_get s (pos+5) = 'n' then (
                        5
                      )
                      else (
                        -1
                      )
                    )
                  | 's' -> (
                      if String.unsafe_get s (pos+1) = 'p' && String.unsafe_get s (pos+2) = 'l' && String.unsafe_get s (pos+3) = 'a' && String.unsafe_get s (pos+4) = 's' && String.unsafe_get s (pos+5) = 'h' then (
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
                if String.unsafe_get s pos = 'm' && String.unsafe_get s (pos+1) = 'e' && String.unsafe_get s (pos+2) = 'm' && String.unsafe_get s (pos+3) = 'b' && String.unsafe_get s (pos+4) = 'e' && String.unsafe_get s (pos+5) = 'r' && String.unsafe_get s (pos+6) = 's' then (
                  24
                )
                else (
                  -1
                )
              )
            | 8 -> (
                match String.unsafe_get s pos with
                  | 'c' -> (
                      if String.unsafe_get s (pos+1) = 'h' && String.unsafe_get s (pos+2) = 'a' && String.unsafe_get s (pos+3) = 'n' && String.unsafe_get s (pos+4) = 'n' && String.unsafe_get s (pos+5) = 'e' && String.unsafe_get s (pos+6) = 'l' && String.unsafe_get s (pos+7) = 's' then (
                        25
                      )
                      else (
                        -1
                      )
                    )
                  | 'f' -> (
                      if String.unsafe_get s (pos+1) = 'e' && String.unsafe_get s (pos+2) = 'a' && String.unsafe_get s (pos+3) = 't' && String.unsafe_get s (pos+4) = 'u' && String.unsafe_get s (pos+5) = 'r' && String.unsafe_get s (pos+6) = 'e' && String.unsafe_get s (pos+7) = 's' then (
                        15
                      )
                      else (
                        -1
                      )
                    )
                  | 'o' -> (
                      if String.unsafe_get s (pos+1) = 'w' && String.unsafe_get s (pos+2) = 'n' && String.unsafe_get s (pos+3) = 'e' && String.unsafe_get s (pos+4) = 'r' && String.unsafe_get s (pos+5) = '_' && String.unsafe_get s (pos+6) = 'i' && String.unsafe_get s (pos+7) = 'd' then (
                        4
                      )
                      else (
                        -1
                      )
                    )
                  | _ -> (
                      -1
                    )
              )
            | 9 -> (
                if String.unsafe_get s pos = 'm' && String.unsafe_get s (pos+1) = 'f' && String.unsafe_get s (pos+2) = 'a' && String.unsafe_get s (pos+3) = '_' && String.unsafe_get s (pos+4) = 'l' && String.unsafe_get s (pos+5) = 'e' && String.unsafe_get s (pos+6) = 'v' && String.unsafe_get s (pos+7) = 'e' && String.unsafe_get s (pos+8) = 'l' then (
                  16
                )
                else (
                  -1
                )
              )
            | 11 -> (
                match String.unsafe_get s pos with
                  | 'a' -> (
                      if String.unsafe_get s (pos+1) = 'f' && String.unsafe_get s (pos+2) = 'k' && String.unsafe_get s (pos+3) = '_' && String.unsafe_get s (pos+4) = 't' && String.unsafe_get s (pos+5) = 'i' && String.unsafe_get s (pos+6) = 'm' && String.unsafe_get s (pos+7) = 'e' && String.unsafe_get s (pos+8) = 'o' && String.unsafe_get s (pos+9) = 'u' && String.unsafe_get s (pos+10) = 't' then (
                        7
                      )
                      else (
                        -1
                      )
                    )
                  | 'u' -> (
                      if String.unsafe_get s (pos+1) = 'n' && String.unsafe_get s (pos+2) = 'a' && String.unsafe_get s (pos+3) = 'v' && String.unsafe_get s (pos+4) = 'a' && String.unsafe_get s (pos+5) = 'i' && String.unsafe_get s (pos+6) = 'l' && String.unsafe_get s (pos+7) = 'a' && String.unsafe_get s (pos+8) = 'b' && String.unsafe_get s (pos+9) = 'l' && String.unsafe_get s (pos+10) = 'e' then (
                        22
                      )
                      else (
                        -1
                      )
                    )
                  | _ -> (
                      -1
                    )
              )
            | 12 -> (
                if String.unsafe_get s pos = 'm' && String.unsafe_get s (pos+1) = 'e' && String.unsafe_get s (pos+2) = 'm' && String.unsafe_get s (pos+3) = 'b' && String.unsafe_get s (pos+4) = 'e' && String.unsafe_get s (pos+5) = 'r' && String.unsafe_get s (pos+6) = '_' && String.unsafe_get s (pos+7) = 'c' && String.unsafe_get s (pos+8) = 'o' && String.unsafe_get s (pos+9) = 'u' && String.unsafe_get s (pos+10) = 'n' && String.unsafe_get s (pos+11) = 't' then (
                  23
                )
                else (
                  -1
                )
              )
            | 13 -> (
                if String.unsafe_get s pos = 'e' && String.unsafe_get s (pos+1) = 'm' && String.unsafe_get s (pos+2) = 'b' && String.unsafe_get s (pos+3) = 'e' && String.unsafe_get s (pos+4) = 'd' && String.unsafe_get s (pos+5) = '_' && String.unsafe_get s (pos+6) = 'e' && String.unsafe_get s (pos+7) = 'n' && String.unsafe_get s (pos+8) = 'a' && String.unsafe_get s (pos+9) = 'b' && String.unsafe_get s (pos+10) = 'l' && String.unsafe_get s (pos+11) = 'e' && String.unsafe_get s (pos+12) = 'd' then (
                  8
                )
                else (
                  -1
                )
              )
            | 14 -> (
                match String.unsafe_get s pos with
                  | 'a' -> (
                      match String.unsafe_get s (pos+1) with
                        | 'f' -> (
                            if String.unsafe_get s (pos+2) = 'k' && String.unsafe_get s (pos+3) = '_' && String.unsafe_get s (pos+4) = 'c' && String.unsafe_get s (pos+5) = 'h' && String.unsafe_get s (pos+6) = 'a' && String.unsafe_get s (pos+7) = 'n' && String.unsafe_get s (pos+8) = 'n' && String.unsafe_get s (pos+9) = 'e' && String.unsafe_get s (pos+10) = 'l' && String.unsafe_get s (pos+11) = '_' && String.unsafe_get s (pos+12) = 'i' && String.unsafe_get s (pos+13) = 'd' then (
                              6
                            )
                            else (
                              -1
                            )
                          )
                        | 'p' -> (
                            if String.unsafe_get s (pos+2) = 'p' && String.unsafe_get s (pos+3) = 'l' && String.unsafe_get s (pos+4) = 'i' && String.unsafe_get s (pos+5) = 'c' && String.unsafe_get s (pos+6) = 'a' && String.unsafe_get s (pos+7) = 't' && String.unsafe_get s (pos+8) = 'i' && String.unsafe_get s (pos+9) = 'o' && String.unsafe_get s (pos+10) = 'n' && String.unsafe_get s (pos+11) = '_' && String.unsafe_get s (pos+12) = 'i' && String.unsafe_get s (pos+13) = 'd' then (
                              17
                            )
                            else (
                              -1
                            )
                          )
                        | _ -> (
                            -1
                          )
                    )
                  | 's' -> (
                      if String.unsafe_get s (pos+1) = 'y' && String.unsafe_get s (pos+2) = 's' && String.unsafe_get s (pos+3) = 't' && String.unsafe_get s (pos+4) = 'e' && String.unsafe_get s (pos+5) = 'm' && String.unsafe_get s (pos+6) = '_' && String.unsafe_get s (pos+7) = 'c' && String.unsafe_get s (pos+8) = 'h' && String.unsafe_get s (pos+9) = 'a' && String.unsafe_get s (pos+10) = 'n' && String.unsafe_get s (pos+11) = 'n' && String.unsafe_get s (pos+12) = 'e' && String.unsafe_get s (pos+13) = 'l' then (
                        20
                      )
                      else (
                        -1
                      )
                    )
                  | 'w' -> (
                      if String.unsafe_get s (pos+1) = 'i' && String.unsafe_get s (pos+2) = 'd' && String.unsafe_get s (pos+3) = 'g' && String.unsafe_get s (pos+4) = 'e' && String.unsafe_get s (pos+5) = 't' && String.unsafe_get s (pos+6) = '_' then (
                        match String.unsafe_get s (pos+7) with
                          | 'c' -> (
                              if String.unsafe_get s (pos+8) = 'h' && String.unsafe_get s (pos+9) = 'a' && String.unsafe_get s (pos+10) = 'n' && String.unsafe_get s (pos+11) = 'n' && String.unsafe_get s (pos+12) = 'e' && String.unsafe_get s (pos+13) = 'l' then (
                                19
                              )
                              else (
                                -1
                              )
                            )
                          | 'e' -> (
                              if String.unsafe_get s (pos+8) = 'n' && String.unsafe_get s (pos+9) = 'a' && String.unsafe_get s (pos+10) = 'b' && String.unsafe_get s (pos+11) = 'l' && String.unsafe_get s (pos+12) = 'e' && String.unsafe_get s (pos+13) = 'd' then (
                                18
                              )
                              else (
                                -1
                              )
                            )
                          | _ -> (
                              -1
                            )
                      )
                      else (
                        -1
                      )
                    )
                  | _ -> (
                      -1
                    )
              )
            | 16 -> (
                if String.unsafe_get s pos = 'e' && String.unsafe_get s (pos+1) = 'm' && String.unsafe_get s (pos+2) = 'b' && String.unsafe_get s (pos+3) = 'e' && String.unsafe_get s (pos+4) = 'd' && String.unsafe_get s (pos+5) = '_' && String.unsafe_get s (pos+6) = 'c' && String.unsafe_get s (pos+7) = 'h' && String.unsafe_get s (pos+8) = 'a' && String.unsafe_get s (pos+9) = 'n' && String.unsafe_get s (pos+10) = 'n' && String.unsafe_get s (pos+11) = 'e' && String.unsafe_get s (pos+12) = 'l' && String.unsafe_get s (pos+13) = '_' && String.unsafe_get s (pos+14) = 'i' && String.unsafe_get s (pos+15) = 'd' then (
                  9
                )
                else (
                  -1
                )
              )
            | 18 -> (
                if String.unsafe_get s pos = 'v' && String.unsafe_get s (pos+1) = 'e' && String.unsafe_get s (pos+2) = 'r' && String.unsafe_get s (pos+3) = 'i' && String.unsafe_get s (pos+4) = 'f' && String.unsafe_get s (pos+5) = 'i' && String.unsafe_get s (pos+6) = 'c' && String.unsafe_get s (pos+7) = 'a' && String.unsafe_get s (pos+8) = 't' && String.unsafe_get s (pos+9) = 'i' && String.unsafe_get s (pos+10) = 'o' && String.unsafe_get s (pos+11) = 'n' && String.unsafe_get s (pos+12) = '_' && String.unsafe_get s (pos+13) = 'l' && String.unsafe_get s (pos+14) = 'e' && String.unsafe_get s (pos+15) = 'v' && String.unsafe_get s (pos+16) = 'e' && String.unsafe_get s (pos+17) = 'l' then (
                  10
                )
                else (
                  -1
                )
              )
            | 23 -> (
                if String.unsafe_get s pos = 'e' && String.unsafe_get s (pos+1) = 'x' && String.unsafe_get s (pos+2) = 'p' && String.unsafe_get s (pos+3) = 'l' && String.unsafe_get s (pos+4) = 'i' && String.unsafe_get s (pos+5) = 'c' && String.unsafe_get s (pos+6) = 'i' && String.unsafe_get s (pos+7) = 't' && String.unsafe_get s (pos+8) = '_' && String.unsafe_get s (pos+9) = 'c' && String.unsafe_get s (pos+10) = 'o' && String.unsafe_get s (pos+11) = 'n' && String.unsafe_get s (pos+12) = 't' && String.unsafe_get s (pos+13) = 'e' && String.unsafe_get s (pos+14) = 'n' && String.unsafe_get s (pos+15) = 't' && String.unsafe_get s (pos+16) = '_' && String.unsafe_get s (pos+17) = 'f' && String.unsafe_get s (pos+18) = 'i' && String.unsafe_get s (pos+19) = 'l' && String.unsafe_get s (pos+20) = 't' && String.unsafe_get s (pos+21) = 'e' && String.unsafe_get s (pos+22) = 'r' then (
                  12
                )
                else (
                  -1
                )
              )
            | 29 -> (
                if String.unsafe_get s pos = 'd' && String.unsafe_get s (pos+1) = 'e' && String.unsafe_get s (pos+2) = 'f' && String.unsafe_get s (pos+3) = 'a' && String.unsafe_get s (pos+4) = 'u' && String.unsafe_get s (pos+5) = 'l' && String.unsafe_get s (pos+6) = 't' && String.unsafe_get s (pos+7) = '_' && String.unsafe_get s (pos+8) = 'm' && String.unsafe_get s (pos+9) = 'e' && String.unsafe_get s (pos+10) = 's' && String.unsafe_get s (pos+11) = 's' && String.unsafe_get s (pos+12) = 'a' && String.unsafe_get s (pos+13) = 'g' && String.unsafe_get s (pos+14) = 'e' && String.unsafe_get s (pos+15) = '_' && String.unsafe_get s (pos+16) = 'n' && String.unsafe_get s (pos+17) = 'o' && String.unsafe_get s (pos+18) = 't' && String.unsafe_get s (pos+19) = 'i' && String.unsafe_get s (pos+20) = 'f' && String.unsafe_get s (pos+21) = 'i' && String.unsafe_get s (pos+22) = 'c' && String.unsafe_get s (pos+23) = 'a' && String.unsafe_get s (pos+24) = 't' && String.unsafe_get s (pos+25) = 'i' && String.unsafe_get s (pos+26) = 'o' && String.unsafe_get s (pos+27) = 'n' && String.unsafe_get s (pos+28) = 's' then (
                  11
                )
                else (
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
            if not (Yojson.Safe.read_null_if_possible p lb) then (
              field_icon := (
                Some (
                  (
                    Atdgen_runtime.Oj_run.read_string
                  ) p lb
                )
              );
            )
          | 3 ->
            if not (Yojson.Safe.read_null_if_possible p lb) then (
              field_splash := (
                Some (
                  (
                    Atdgen_runtime.Oj_run.read_string
                  ) p lb
                )
              );
            )
          | 4 ->
            field_owner_id := (
              (
                read_snowflake
              ) p lb
            );
            bits0 := !bits0 lor 0x4;
          | 5 ->
            field_region := (
              (
                Atdgen_runtime.Oj_run.read_string
              ) p lb
            );
            bits0 := !bits0 lor 0x8;
          | 6 ->
            if not (Yojson.Safe.read_null_if_possible p lb) then (
              field_afk_channel_id := (
                Some (
                  (
                    read_snowflake
                  ) p lb
                )
              );
            )
          | 7 ->
            field_afk_timeout := (
              (
                Atdgen_runtime.Oj_run.read_int
              ) p lb
            );
            bits0 := !bits0 lor 0x10;
          | 8 ->
            if not (Yojson.Safe.read_null_if_possible p lb) then (
              field_embed_enabled := (
                Some (
                  (
                    Atdgen_runtime.Oj_run.read_bool
                  ) p lb
                )
              );
            )
          | 9 ->
            if not (Yojson.Safe.read_null_if_possible p lb) then (
              field_embed_channel_id := (
                Some (
                  (
                    read_snowflake
                  ) p lb
                )
              );
            )
          | 10 ->
            field_verification_level := (
              (
                Atdgen_runtime.Oj_run.read_int
              ) p lb
            );
            bits0 := !bits0 lor 0x20;
          | 11 ->
            field_default_message_notifications := (
              (
                Atdgen_runtime.Oj_run.read_int
              ) p lb
            );
            bits0 := !bits0 lor 0x40;
          | 12 ->
            field_explicit_content_filter := (
              (
                Atdgen_runtime.Oj_run.read_int
              ) p lb
            );
            bits0 := !bits0 lor 0x80;
          | 13 ->
            field_roles := (
              (
                read__4
              ) p lb
            );
            bits0 := !bits0 lor 0x100;
          | 14 ->
            field_emojis := (
              (
                read__5
              ) p lb
            );
            bits0 := !bits0 lor 0x200;
          | 15 ->
            field_features := (
              (
                read__6
              ) p lb
            );
            bits0 := !bits0 lor 0x400;
          | 16 ->
            field_mfa_level := (
              (
                Atdgen_runtime.Oj_run.read_int
              ) p lb
            );
            bits0 := !bits0 lor 0x800;
          | 17 ->
            if not (Yojson.Safe.read_null_if_possible p lb) then (
              field_application_id := (
                Some (
                  (
                    read_snowflake
                  ) p lb
                )
              );
            )
          | 18 ->
            if not (Yojson.Safe.read_null_if_possible p lb) then (
              field_widget_enabled := (
                Some (
                  (
                    Atdgen_runtime.Oj_run.read_bool
                  ) p lb
                )
              );
            )
          | 19 ->
            if not (Yojson.Safe.read_null_if_possible p lb) then (
              field_widget_channel := (
                Some (
                  (
                    read_channel
                  ) p lb
                )
              );
            )
          | 20 ->
            if not (Yojson.Safe.read_null_if_possible p lb) then (
              field_system_channel := (
                Some (
                  (
                    read_channel
                  ) p lb
                )
              );
            )
          | 21 ->
            if not (Yojson.Safe.read_null_if_possible p lb) then (
              field_large := (
                Some (
                  (
                    Atdgen_runtime.Oj_run.read_bool
                  ) p lb
                )
              );
            )
          | 22 ->
            if not (Yojson.Safe.read_null_if_possible p lb) then (
              field_unavailable := (
                Some (
                  (
                    Atdgen_runtime.Oj_run.read_bool
                  ) p lb
                )
              );
            )
          | 23 ->
            if not (Yojson.Safe.read_null_if_possible p lb) then (
              field_member_count := (
                Some (
                  (
                    Atdgen_runtime.Oj_run.read_int
                  ) p lb
                )
              );
            )
          | 24 ->
            if not (Yojson.Safe.read_null_if_possible p lb) then (
              field_members := (
                (
                  read__9
                ) p lb
              );
            )
          | 25 ->
            if not (Yojson.Safe.read_null_if_possible p lb) then (
              field_channels := (
                (
                  read__10
                ) p lb
              );
            )
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
                  match String.unsafe_get s pos with
                    | 'i' -> (
                        if String.unsafe_get s (pos+1) = 'c' && String.unsafe_get s (pos+2) = 'o' && String.unsafe_get s (pos+3) = 'n' then (
                          2
                        )
                        else (
                          -1
                        )
                      )
                    | 'n' -> (
                        if String.unsafe_get s (pos+1) = 'a' && String.unsafe_get s (pos+2) = 'm' && String.unsafe_get s (pos+3) = 'e' then (
                          1
                        )
                        else (
                          -1
                        )
                      )
                    | _ -> (
                        -1
                      )
                )
              | 5 -> (
                  match String.unsafe_get s pos with
                    | 'l' -> (
                        if String.unsafe_get s (pos+1) = 'a' && String.unsafe_get s (pos+2) = 'r' && String.unsafe_get s (pos+3) = 'g' && String.unsafe_get s (pos+4) = 'e' then (
                          21
                        )
                        else (
                          -1
                        )
                      )
                    | 'r' -> (
                        if String.unsafe_get s (pos+1) = 'o' && String.unsafe_get s (pos+2) = 'l' && String.unsafe_get s (pos+3) = 'e' && String.unsafe_get s (pos+4) = 's' then (
                          13
                        )
                        else (
                          -1
                        )
                      )
                    | _ -> (
                        -1
                      )
                )
              | 6 -> (
                  match String.unsafe_get s pos with
                    | 'e' -> (
                        if String.unsafe_get s (pos+1) = 'm' && String.unsafe_get s (pos+2) = 'o' && String.unsafe_get s (pos+3) = 'j' && String.unsafe_get s (pos+4) = 'i' && String.unsafe_get s (pos+5) = 's' then (
                          14
                        )
                        else (
                          -1
                        )
                      )
                    | 'r' -> (
                        if String.unsafe_get s (pos+1) = 'e' && String.unsafe_get s (pos+2) = 'g' && String.unsafe_get s (pos+3) = 'i' && String.unsafe_get s (pos+4) = 'o' && String.unsafe_get s (pos+5) = 'n' then (
                          5
                        )
                        else (
                          -1
                        )
                      )
                    | 's' -> (
                        if String.unsafe_get s (pos+1) = 'p' && String.unsafe_get s (pos+2) = 'l' && String.unsafe_get s (pos+3) = 'a' && String.unsafe_get s (pos+4) = 's' && String.unsafe_get s (pos+5) = 'h' then (
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
                  if String.unsafe_get s pos = 'm' && String.unsafe_get s (pos+1) = 'e' && String.unsafe_get s (pos+2) = 'm' && String.unsafe_get s (pos+3) = 'b' && String.unsafe_get s (pos+4) = 'e' && String.unsafe_get s (pos+5) = 'r' && String.unsafe_get s (pos+6) = 's' then (
                    24
                  )
                  else (
                    -1
                  )
                )
              | 8 -> (
                  match String.unsafe_get s pos with
                    | 'c' -> (
                        if String.unsafe_get s (pos+1) = 'h' && String.unsafe_get s (pos+2) = 'a' && String.unsafe_get s (pos+3) = 'n' && String.unsafe_get s (pos+4) = 'n' && String.unsafe_get s (pos+5) = 'e' && String.unsafe_get s (pos+6) = 'l' && String.unsafe_get s (pos+7) = 's' then (
                          25
                        )
                        else (
                          -1
                        )
                      )
                    | 'f' -> (
                        if String.unsafe_get s (pos+1) = 'e' && String.unsafe_get s (pos+2) = 'a' && String.unsafe_get s (pos+3) = 't' && String.unsafe_get s (pos+4) = 'u' && String.unsafe_get s (pos+5) = 'r' && String.unsafe_get s (pos+6) = 'e' && String.unsafe_get s (pos+7) = 's' then (
                          15
                        )
                        else (
                          -1
                        )
                      )
                    | 'o' -> (
                        if String.unsafe_get s (pos+1) = 'w' && String.unsafe_get s (pos+2) = 'n' && String.unsafe_get s (pos+3) = 'e' && String.unsafe_get s (pos+4) = 'r' && String.unsafe_get s (pos+5) = '_' && String.unsafe_get s (pos+6) = 'i' && String.unsafe_get s (pos+7) = 'd' then (
                          4
                        )
                        else (
                          -1
                        )
                      )
                    | _ -> (
                        -1
                      )
                )
              | 9 -> (
                  if String.unsafe_get s pos = 'm' && String.unsafe_get s (pos+1) = 'f' && String.unsafe_get s (pos+2) = 'a' && String.unsafe_get s (pos+3) = '_' && String.unsafe_get s (pos+4) = 'l' && String.unsafe_get s (pos+5) = 'e' && String.unsafe_get s (pos+6) = 'v' && String.unsafe_get s (pos+7) = 'e' && String.unsafe_get s (pos+8) = 'l' then (
                    16
                  )
                  else (
                    -1
                  )
                )
              | 11 -> (
                  match String.unsafe_get s pos with
                    | 'a' -> (
                        if String.unsafe_get s (pos+1) = 'f' && String.unsafe_get s (pos+2) = 'k' && String.unsafe_get s (pos+3) = '_' && String.unsafe_get s (pos+4) = 't' && String.unsafe_get s (pos+5) = 'i' && String.unsafe_get s (pos+6) = 'm' && String.unsafe_get s (pos+7) = 'e' && String.unsafe_get s (pos+8) = 'o' && String.unsafe_get s (pos+9) = 'u' && String.unsafe_get s (pos+10) = 't' then (
                          7
                        )
                        else (
                          -1
                        )
                      )
                    | 'u' -> (
                        if String.unsafe_get s (pos+1) = 'n' && String.unsafe_get s (pos+2) = 'a' && String.unsafe_get s (pos+3) = 'v' && String.unsafe_get s (pos+4) = 'a' && String.unsafe_get s (pos+5) = 'i' && String.unsafe_get s (pos+6) = 'l' && String.unsafe_get s (pos+7) = 'a' && String.unsafe_get s (pos+8) = 'b' && String.unsafe_get s (pos+9) = 'l' && String.unsafe_get s (pos+10) = 'e' then (
                          22
                        )
                        else (
                          -1
                        )
                      )
                    | _ -> (
                        -1
                      )
                )
              | 12 -> (
                  if String.unsafe_get s pos = 'm' && String.unsafe_get s (pos+1) = 'e' && String.unsafe_get s (pos+2) = 'm' && String.unsafe_get s (pos+3) = 'b' && String.unsafe_get s (pos+4) = 'e' && String.unsafe_get s (pos+5) = 'r' && String.unsafe_get s (pos+6) = '_' && String.unsafe_get s (pos+7) = 'c' && String.unsafe_get s (pos+8) = 'o' && String.unsafe_get s (pos+9) = 'u' && String.unsafe_get s (pos+10) = 'n' && String.unsafe_get s (pos+11) = 't' then (
                    23
                  )
                  else (
                    -1
                  )
                )
              | 13 -> (
                  if String.unsafe_get s pos = 'e' && String.unsafe_get s (pos+1) = 'm' && String.unsafe_get s (pos+2) = 'b' && String.unsafe_get s (pos+3) = 'e' && String.unsafe_get s (pos+4) = 'd' && String.unsafe_get s (pos+5) = '_' && String.unsafe_get s (pos+6) = 'e' && String.unsafe_get s (pos+7) = 'n' && String.unsafe_get s (pos+8) = 'a' && String.unsafe_get s (pos+9) = 'b' && String.unsafe_get s (pos+10) = 'l' && String.unsafe_get s (pos+11) = 'e' && String.unsafe_get s (pos+12) = 'd' then (
                    8
                  )
                  else (
                    -1
                  )
                )
              | 14 -> (
                  match String.unsafe_get s pos with
                    | 'a' -> (
                        match String.unsafe_get s (pos+1) with
                          | 'f' -> (
                              if String.unsafe_get s (pos+2) = 'k' && String.unsafe_get s (pos+3) = '_' && String.unsafe_get s (pos+4) = 'c' && String.unsafe_get s (pos+5) = 'h' && String.unsafe_get s (pos+6) = 'a' && String.unsafe_get s (pos+7) = 'n' && String.unsafe_get s (pos+8) = 'n' && String.unsafe_get s (pos+9) = 'e' && String.unsafe_get s (pos+10) = 'l' && String.unsafe_get s (pos+11) = '_' && String.unsafe_get s (pos+12) = 'i' && String.unsafe_get s (pos+13) = 'd' then (
                                6
                              )
                              else (
                                -1
                              )
                            )
                          | 'p' -> (
                              if String.unsafe_get s (pos+2) = 'p' && String.unsafe_get s (pos+3) = 'l' && String.unsafe_get s (pos+4) = 'i' && String.unsafe_get s (pos+5) = 'c' && String.unsafe_get s (pos+6) = 'a' && String.unsafe_get s (pos+7) = 't' && String.unsafe_get s (pos+8) = 'i' && String.unsafe_get s (pos+9) = 'o' && String.unsafe_get s (pos+10) = 'n' && String.unsafe_get s (pos+11) = '_' && String.unsafe_get s (pos+12) = 'i' && String.unsafe_get s (pos+13) = 'd' then (
                                17
                              )
                              else (
                                -1
                              )
                            )
                          | _ -> (
                              -1
                            )
                      )
                    | 's' -> (
                        if String.unsafe_get s (pos+1) = 'y' && String.unsafe_get s (pos+2) = 's' && String.unsafe_get s (pos+3) = 't' && String.unsafe_get s (pos+4) = 'e' && String.unsafe_get s (pos+5) = 'm' && String.unsafe_get s (pos+6) = '_' && String.unsafe_get s (pos+7) = 'c' && String.unsafe_get s (pos+8) = 'h' && String.unsafe_get s (pos+9) = 'a' && String.unsafe_get s (pos+10) = 'n' && String.unsafe_get s (pos+11) = 'n' && String.unsafe_get s (pos+12) = 'e' && String.unsafe_get s (pos+13) = 'l' then (
                          20
                        )
                        else (
                          -1
                        )
                      )
                    | 'w' -> (
                        if String.unsafe_get s (pos+1) = 'i' && String.unsafe_get s (pos+2) = 'd' && String.unsafe_get s (pos+3) = 'g' && String.unsafe_get s (pos+4) = 'e' && String.unsafe_get s (pos+5) = 't' && String.unsafe_get s (pos+6) = '_' then (
                          match String.unsafe_get s (pos+7) with
                            | 'c' -> (
                                if String.unsafe_get s (pos+8) = 'h' && String.unsafe_get s (pos+9) = 'a' && String.unsafe_get s (pos+10) = 'n' && String.unsafe_get s (pos+11) = 'n' && String.unsafe_get s (pos+12) = 'e' && String.unsafe_get s (pos+13) = 'l' then (
                                  19
                                )
                                else (
                                  -1
                                )
                              )
                            | 'e' -> (
                                if String.unsafe_get s (pos+8) = 'n' && String.unsafe_get s (pos+9) = 'a' && String.unsafe_get s (pos+10) = 'b' && String.unsafe_get s (pos+11) = 'l' && String.unsafe_get s (pos+12) = 'e' && String.unsafe_get s (pos+13) = 'd' then (
                                  18
                                )
                                else (
                                  -1
                                )
                              )
                            | _ -> (
                                -1
                              )
                        )
                        else (
                          -1
                        )
                      )
                    | _ -> (
                        -1
                      )
                )
              | 16 -> (
                  if String.unsafe_get s pos = 'e' && String.unsafe_get s (pos+1) = 'm' && String.unsafe_get s (pos+2) = 'b' && String.unsafe_get s (pos+3) = 'e' && String.unsafe_get s (pos+4) = 'd' && String.unsafe_get s (pos+5) = '_' && String.unsafe_get s (pos+6) = 'c' && String.unsafe_get s (pos+7) = 'h' && String.unsafe_get s (pos+8) = 'a' && String.unsafe_get s (pos+9) = 'n' && String.unsafe_get s (pos+10) = 'n' && String.unsafe_get s (pos+11) = 'e' && String.unsafe_get s (pos+12) = 'l' && String.unsafe_get s (pos+13) = '_' && String.unsafe_get s (pos+14) = 'i' && String.unsafe_get s (pos+15) = 'd' then (
                    9
                  )
                  else (
                    -1
                  )
                )
              | 18 -> (
                  if String.unsafe_get s pos = 'v' && String.unsafe_get s (pos+1) = 'e' && String.unsafe_get s (pos+2) = 'r' && String.unsafe_get s (pos+3) = 'i' && String.unsafe_get s (pos+4) = 'f' && String.unsafe_get s (pos+5) = 'i' && String.unsafe_get s (pos+6) = 'c' && String.unsafe_get s (pos+7) = 'a' && String.unsafe_get s (pos+8) = 't' && String.unsafe_get s (pos+9) = 'i' && String.unsafe_get s (pos+10) = 'o' && String.unsafe_get s (pos+11) = 'n' && String.unsafe_get s (pos+12) = '_' && String.unsafe_get s (pos+13) = 'l' && String.unsafe_get s (pos+14) = 'e' && String.unsafe_get s (pos+15) = 'v' && String.unsafe_get s (pos+16) = 'e' && String.unsafe_get s (pos+17) = 'l' then (
                    10
                  )
                  else (
                    -1
                  )
                )
              | 23 -> (
                  if String.unsafe_get s pos = 'e' && String.unsafe_get s (pos+1) = 'x' && String.unsafe_get s (pos+2) = 'p' && String.unsafe_get s (pos+3) = 'l' && String.unsafe_get s (pos+4) = 'i' && String.unsafe_get s (pos+5) = 'c' && String.unsafe_get s (pos+6) = 'i' && String.unsafe_get s (pos+7) = 't' && String.unsafe_get s (pos+8) = '_' && String.unsafe_get s (pos+9) = 'c' && String.unsafe_get s (pos+10) = 'o' && String.unsafe_get s (pos+11) = 'n' && String.unsafe_get s (pos+12) = 't' && String.unsafe_get s (pos+13) = 'e' && String.unsafe_get s (pos+14) = 'n' && String.unsafe_get s (pos+15) = 't' && String.unsafe_get s (pos+16) = '_' && String.unsafe_get s (pos+17) = 'f' && String.unsafe_get s (pos+18) = 'i' && String.unsafe_get s (pos+19) = 'l' && String.unsafe_get s (pos+20) = 't' && String.unsafe_get s (pos+21) = 'e' && String.unsafe_get s (pos+22) = 'r' then (
                    12
                  )
                  else (
                    -1
                  )
                )
              | 29 -> (
                  if String.unsafe_get s pos = 'd' && String.unsafe_get s (pos+1) = 'e' && String.unsafe_get s (pos+2) = 'f' && String.unsafe_get s (pos+3) = 'a' && String.unsafe_get s (pos+4) = 'u' && String.unsafe_get s (pos+5) = 'l' && String.unsafe_get s (pos+6) = 't' && String.unsafe_get s (pos+7) = '_' && String.unsafe_get s (pos+8) = 'm' && String.unsafe_get s (pos+9) = 'e' && String.unsafe_get s (pos+10) = 's' && String.unsafe_get s (pos+11) = 's' && String.unsafe_get s (pos+12) = 'a' && String.unsafe_get s (pos+13) = 'g' && String.unsafe_get s (pos+14) = 'e' && String.unsafe_get s (pos+15) = '_' && String.unsafe_get s (pos+16) = 'n' && String.unsafe_get s (pos+17) = 'o' && String.unsafe_get s (pos+18) = 't' && String.unsafe_get s (pos+19) = 'i' && String.unsafe_get s (pos+20) = 'f' && String.unsafe_get s (pos+21) = 'i' && String.unsafe_get s (pos+22) = 'c' && String.unsafe_get s (pos+23) = 'a' && String.unsafe_get s (pos+24) = 't' && String.unsafe_get s (pos+25) = 'i' && String.unsafe_get s (pos+26) = 'o' && String.unsafe_get s (pos+27) = 'n' && String.unsafe_get s (pos+28) = 's' then (
                    11
                  )
                  else (
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
              if not (Yojson.Safe.read_null_if_possible p lb) then (
                field_icon := (
                  Some (
                    (
                      Atdgen_runtime.Oj_run.read_string
                    ) p lb
                  )
                );
              )
            | 3 ->
              if not (Yojson.Safe.read_null_if_possible p lb) then (
                field_splash := (
                  Some (
                    (
                      Atdgen_runtime.Oj_run.read_string
                    ) p lb
                  )
                );
              )
            | 4 ->
              field_owner_id := (
                (
                  read_snowflake
                ) p lb
              );
              bits0 := !bits0 lor 0x4;
            | 5 ->
              field_region := (
                (
                  Atdgen_runtime.Oj_run.read_string
                ) p lb
              );
              bits0 := !bits0 lor 0x8;
            | 6 ->
              if not (Yojson.Safe.read_null_if_possible p lb) then (
                field_afk_channel_id := (
                  Some (
                    (
                      read_snowflake
                    ) p lb
                  )
                );
              )
            | 7 ->
              field_afk_timeout := (
                (
                  Atdgen_runtime.Oj_run.read_int
                ) p lb
              );
              bits0 := !bits0 lor 0x10;
            | 8 ->
              if not (Yojson.Safe.read_null_if_possible p lb) then (
                field_embed_enabled := (
                  Some (
                    (
                      Atdgen_runtime.Oj_run.read_bool
                    ) p lb
                  )
                );
              )
            | 9 ->
              if not (Yojson.Safe.read_null_if_possible p lb) then (
                field_embed_channel_id := (
                  Some (
                    (
                      read_snowflake
                    ) p lb
                  )
                );
              )
            | 10 ->
              field_verification_level := (
                (
                  Atdgen_runtime.Oj_run.read_int
                ) p lb
              );
              bits0 := !bits0 lor 0x20;
            | 11 ->
              field_default_message_notifications := (
                (
                  Atdgen_runtime.Oj_run.read_int
                ) p lb
              );
              bits0 := !bits0 lor 0x40;
            | 12 ->
              field_explicit_content_filter := (
                (
                  Atdgen_runtime.Oj_run.read_int
                ) p lb
              );
              bits0 := !bits0 lor 0x80;
            | 13 ->
              field_roles := (
                (
                  read__4
                ) p lb
              );
              bits0 := !bits0 lor 0x100;
            | 14 ->
              field_emojis := (
                (
                  read__5
                ) p lb
              );
              bits0 := !bits0 lor 0x200;
            | 15 ->
              field_features := (
                (
                  read__6
                ) p lb
              );
              bits0 := !bits0 lor 0x400;
            | 16 ->
              field_mfa_level := (
                (
                  Atdgen_runtime.Oj_run.read_int
                ) p lb
              );
              bits0 := !bits0 lor 0x800;
            | 17 ->
              if not (Yojson.Safe.read_null_if_possible p lb) then (
                field_application_id := (
                  Some (
                    (
                      read_snowflake
                    ) p lb
                  )
                );
              )
            | 18 ->
              if not (Yojson.Safe.read_null_if_possible p lb) then (
                field_widget_enabled := (
                  Some (
                    (
                      Atdgen_runtime.Oj_run.read_bool
                    ) p lb
                  )
                );
              )
            | 19 ->
              if not (Yojson.Safe.read_null_if_possible p lb) then (
                field_widget_channel := (
                  Some (
                    (
                      read_channel
                    ) p lb
                  )
                );
              )
            | 20 ->
              if not (Yojson.Safe.read_null_if_possible p lb) then (
                field_system_channel := (
                  Some (
                    (
                      read_channel
                    ) p lb
                  )
                );
              )
            | 21 ->
              if not (Yojson.Safe.read_null_if_possible p lb) then (
                field_large := (
                  Some (
                    (
                      Atdgen_runtime.Oj_run.read_bool
                    ) p lb
                  )
                );
              )
            | 22 ->
              if not (Yojson.Safe.read_null_if_possible p lb) then (
                field_unavailable := (
                  Some (
                    (
                      Atdgen_runtime.Oj_run.read_bool
                    ) p lb
                  )
                );
              )
            | 23 ->
              if not (Yojson.Safe.read_null_if_possible p lb) then (
                field_member_count := (
                  Some (
                    (
                      Atdgen_runtime.Oj_run.read_int
                    ) p lb
                  )
                );
              )
            | 24 ->
              if not (Yojson.Safe.read_null_if_possible p lb) then (
                field_members := (
                  (
                    read__9
                  ) p lb
                );
              )
            | 25 ->
              if not (Yojson.Safe.read_null_if_possible p lb) then (
                field_channels := (
                  (
                    read__10
                  ) p lb
                );
              )
            | _ -> (
                Yojson.Safe.skip_json p lb
              )
        );
      done;
      assert false;
    with Yojson.End_of_object -> (
        if !bits0 <> 0xfff then Atdgen_runtime.Oj_run.missing_fields p [| !bits0 |] [| "id"; "name"; "owner_id"; "region"; "afk_timeout"; "verification_level"; "default_message_notifications"; "explicit_content_filter"; "roles"; "emojis"; "features"; "mfa_level" |];
        (
          {
            id = !field_id;
            name = !field_name;
            icon = !field_icon;
            splash = !field_splash;
            owner_id = !field_owner_id;
            region = !field_region;
            afk_channel_id = !field_afk_channel_id;
            afk_timeout = !field_afk_timeout;
            embed_enabled = !field_embed_enabled;
            embed_channel_id = !field_embed_channel_id;
            verification_level = !field_verification_level;
            default_message_notifications = !field_default_message_notifications;
            explicit_content_filter = !field_explicit_content_filter;
            roles = !field_roles;
            emojis = !field_emojis;
            features = !field_features;
            mfa_level = !field_mfa_level;
            application_id = !field_application_id;
            widget_enabled = !field_widget_enabled;
            widget_channel = !field_widget_channel;
            system_channel = !field_system_channel;
            large = !field_large;
            unavailable = !field_unavailable;
            member_count = !field_member_count;
            members = !field_members;
            channels = !field_channels;
          }
         : t)
      )
)
let t_of_string s =
  read_t (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
