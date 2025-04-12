module Game

export Loop, State

include("state/state.jl")
include("loop/loop.jl")

using .State
using .Loop

end