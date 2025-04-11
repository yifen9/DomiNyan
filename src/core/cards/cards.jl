module Cards

include("types/types.jl")
using .Types

include("../player/player.jl")
using .Player

include("registry/registry.jl")
using .Registry

include("play/play_logic.jl")

include("loader/loader_sets.jl")

export Card, CardTreasure, CardVictory, CardAction
export CARD_REGISTRY, card_set, card_get, card_get_field, card_get_play
export play

end