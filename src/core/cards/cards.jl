# src/core/cards/cards.jl
module Cards

export Registry, SetsLoader

include("registry/registry.jl")      # defines Cards.Registry
using .Registry

# Convenience macro – no need for a separate file
"""
    @register sym expr

Create a CardTemplate via `expr` and register under `sym`.
"""
macro register(sym, expr)
    quote
        if Cards.Registry.exists($(esc(sym)))
            @warn "Card $(string($(esc(sym)))) is being overwritten."
        end
        Cards.Registry.set!($(esc(sym)), $(esc(expr)))
    end
end
export @register

include("loader/sets_loader.jl")     # defines Cards.SetsLoader
using .SetsLoader

end # module Cards