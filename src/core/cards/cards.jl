module Cards

include("loader/loader_registry.jl")
using .RegistryLoader

load_registries_all("registry")

include("types/types.jl")
include("play/play_logic.jl")

using .Types
using .Registry

include("loader/loader_sets.jl")

export Card, CardTreasure, CardVictory, CardAction, card_get, play

end