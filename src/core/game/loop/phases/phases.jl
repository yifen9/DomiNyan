module Phases

include("core/setup.jl")
include("core/action.jl")
include("core/buy.jl")
include("core/cleanup.jl")

using .Setup, .Action, .Buy, .Cleanup

end