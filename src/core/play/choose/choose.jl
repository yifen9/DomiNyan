module Choose

export Registry, Utils, Loader, choose

include("registry/strategies_registry.jl")
include("utils/utils.jl")
include("loader/strategies_loader.jl")

using .Registry
using .Utils
using .Loader

"""
    choose(name::Symbol = :random, args...)

Dispatch to the strategy registered under `name`.  
Falls back to `:random` if `name` is not found.  
Returns whatever the strategy function returns.
"""
function choose(name::Symbol = :random, args...)
    # look up in the global dictionary; fallback to :random
    if haskey(Registry.STRATEGIES, name)
        return Registry.get(name)(args...)
    else
        return Registry.get(:random)(args...)
    end
end

end # module Choose