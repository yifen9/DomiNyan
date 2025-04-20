module Game

export State, Loop

include("state/state.jl")
include("loop/loop.jl")

using .State
using .Loop

end