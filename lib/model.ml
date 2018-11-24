module Make(M: S.Model) = struct
    include M
end

module Message = Make(Message)
module Guild = Make(Guild)
module Channel = Make(Channel)

exception Type_Mismatch

type t =
    | Message of Message.t
    | Guild of Guild.t
    | Channel of Channel.t

let to_message = function
    | Message m -> m
    | _ -> raise Type_Mismatch

let to_guild = function
    | Guild m -> m
    | _ -> raise Type_Mismatch

let to_channel = function
    | Channel m -> m
    | _ -> raise Type_Mismatch