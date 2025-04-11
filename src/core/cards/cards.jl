module Cards

include("card_types.jl")
include("card_registry.jl")
include("loader/sets_loader.jl")

export Card, CardTreasure, CardVictory, CardAction
export card_get, card_register, CARD_REGISTRY
export play

end