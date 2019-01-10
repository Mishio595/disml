module Make(Http : S.Http) = struct
	type partial_member = Member_t.partial_member
	type member = Member_t.member
	type member_update = Member_t.member_update
	type t = Member_t.t
	(* val add_role : Member_t.t -> Role_t.t -> Yojson.Safe.json Deferred.t
	val remove_role : Member_t.t -> Role_t.t -> Yojson.Safe.json Deferred.t
	val ban : ?reason:string -> ?days:int -> Member_t.t -> Yojson.Safe.json Deferred.t
	val ban : ?reason:string -> Member_t.t -> Yojson.Safe.json Deferred.t
	val kick : ?reason:string -> Member_t.t -> Yojson.Safe.json Deferred.t
	val mute : Member_t.t -> Yojson.Safe.json Deferred.t
	val deafen : Member_t.t -> Yojson.Safe.json Deferred.t
	val unmute : Member_t.t -> Yojson.Safe.json Deferred.t
	val undeafen : Member_t.t -> Yojson.Safe.json Deferred.t *)
end