module Phases

include("core/start.jl")
include("core/action.jl")
include("core/buy.jl")
include("core/cleanup.jl")

using .Start, .Action, .Buy, .Cleanup

end