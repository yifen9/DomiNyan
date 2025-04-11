module Cards

include("types/types.jl")
using .Types

include("registry/registry.jl")
using .Registry

include("loader/sets_loader.jl")

export types_Card, types_CardTreasure, types_CardVictory, types_CardAction
export REGISTRY, registry_set, registry_get, registry_get_field, registry_get_play

end