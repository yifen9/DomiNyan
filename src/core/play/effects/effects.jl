module Effects

# ----------------------------------------------------------------------
# Public API
# ----------------------------------------------------------------------
export Registry,                 # sub‑module
       Loader,
       Pipeline,
       dispatch                  # execute effects attached to a card

# ----------------------------------------------------------------------
# Sub‑module: Registry (Symbol ⇒ Function)
# ----------------------------------------------------------------------
include("registry/registry.jl")  # defines module Registry
include("loader/core_loader.jl")
include("pipeline/pipeline.jl")

using .Registry
using .Loader
using .Pipeline

# ───────────────────────────
# Core dispatcher
# ───────────────────────────
using ..Types
using ..Player

"""
    dispatch(card, player, game; args=nothing) -> Vector

Execute every effect symbol stored in `card.data[:effects]`
and return a vector of their results.
"""
function dispatch(card::Types.CardTemplate, player::Player.State, game; args = nothing)
    syms = Base.get(card.data, :effects, Symbol[])
    isempty(syms) && return Vector{Any}()

    results = Vector{Any}(undef, length(syms))
    for (i, sym) in pairs(syms)
        f   = Registry.get(sym)
        arg = haskey(card.data, sym) ? card.data[sym] : args
        results[i] = f(player, game, arg)
    end
    return results
end

end # module Effects