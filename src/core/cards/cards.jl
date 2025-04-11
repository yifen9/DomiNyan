module Cards

include("types/types.jl")
include("registry/registry.jl")

using .Types
using .Registry

include("loader/sets_loader.jl")

export Card, CardTreasure, CardVictory, CardAction
export card_get, card_register, CARD_REGISTRY
export play

end