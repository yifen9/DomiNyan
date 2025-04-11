module Cards

include("cards_types.jl")
using .CardsTypes

include("cards_registry.jl")
using .CardsRegistry

include("sets/sets_loader.jl")

export Card, CardTreasure, CardVictory, CardAction
export CARD_REGISTRY, card_set, card_get, card_get_field, card_get_play

end