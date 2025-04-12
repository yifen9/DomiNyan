module Game

export State, Logger, Loop

include("state/state.jl")
include("logger/logger.jl")
include("loop/loop.jl")

using .State
using .Logger
using .Loop

end