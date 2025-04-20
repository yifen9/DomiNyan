# src/core/cards/cards.jl
module Cards

export Registry, Loader

include("registry/registry.jl")      # defines Cards.Registry
include("loader/sets_loader.jl")     # defines Cards.Loader

using .Registry
using .Loader

end # module Cards