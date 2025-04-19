module Effects

# ----------------------------------------------------------------------
# Public API
# ----------------------------------------------------------------------
export Registry,                 # sub‑module
       core_load!,               # one‑shot loader for effects in ./core
       dispatch,                 # execute effects attached to a card
       @register         # macro for effect authors

# ----------------------------------------------------------------------
# Sub‑module: Registry (Symbol ⇒ Function)
# ----------------------------------------------------------------------
include("registry/registry.jl")  # defines module Registry

# ----------------------------------------------------------------------
# Convenience macro for effect authors
# ----------------------------------------------------------------------
"""
    @register sym fn

register `fn` under the symbol `sym` at compile time.  Usage in an
individual effect file:

```julia
@register :action_gain action_gain!
```

If `sym` already exists it will be overwritten **with a warning**,
avoiding accidental duplicate registrations during `Revise.jl` hot‑reload.
"""
macro register(sym, fn)
    return quote
        if haskey(Registry.REGISTRY, $(esc(sym)))
            @warn "Effect $(string($(esc(sym)))) is being overwritten."   
        end
        Registry.set!($(esc(sym)), $(esc(fn)))
    end
end

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

# ───────────────────────────
# Loader (idempotent)
# ───────────────────────────
using Dates: now

const _core_loaded_at = Ref{Union{Nothing,Float64}}(nothing)

"""
    core_load!() -> Nothing

Include every `*.jl` in ./core **once**, unless the file set
or timestamps have changed.
"""
function core_load!()
    dir_core = normpath(joinpath(@__DIR__, "core"))
    files = filter(f -> endswith(f, ".jl"), readdir(dir_core; join=true))
    isempty(files) && return nothing     # nothing to load
    change_last = maximum(stat(file).mtime for file in files)
    if !isnothing(_core_loaded_at[]) && _core_loaded_at[] ≥ change_last
        return nothing
    end
    for file in sort(files)
        include(file)
    end
    _core_loaded_at[] = change_last
    return nothing
end

core_load!()

end # module Effects