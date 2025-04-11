module Play

using ..Cards.Types: types_Card

# Include all submodules
include("player.jl")
include("dispatcher.jl")

for file in readdir(joinpath(@__DIR__, "effects"))
    if endswith(file, ".jl")
        include(joinpath("effects", file))
    end
end

# Use selected symbols from submodules
using .Player: PlayerState, player_new
using .Dispatcher: dispatcher

using .Draw: draw_cards!

# Export unified API
export PlayerState, player_new
export play_dispatcher
export draw_cards!

end