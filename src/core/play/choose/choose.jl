module Choose

export choose

include("registry/strategies_registry.jl")
include("loader/strategies_loader.jl")
include("utils/utils.jl")

using .Registry
using .Loader
using .Utils

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