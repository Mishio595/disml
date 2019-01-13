module Make(H : S.Http) = struct
    module Ban = Ban.Make(H)
    module Channel = Channel.Make(H)
    module Guild = Guild.Make(H)
    module Member = Member.Make(H)
    module Message = Message.Make(H)
    module Reaction = Reaction.Make(H)
    module Role = Role.Make(H)
    module User = User.Make(H)
end