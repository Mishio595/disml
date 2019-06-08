include module type of User_t

(** The user tag. Equivalent to concatenating the username and discriminator, separated by a '#'. *)
val tag : t -> string

(** The mention string for the user. Equivalent to [<@USER_ID>]. *)
val mention : t -> string

(** The default avatar for the user. *)
val default_avatar : t -> Endpoints.t

(** The avatar url of the user, falling back to the default avatar. *)
val face : t -> Endpoints.t