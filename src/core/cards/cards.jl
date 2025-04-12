module Cards

export Registry

include("registry/registry.jl")

using .Registry

include("loader/sets_loader.jl")

end