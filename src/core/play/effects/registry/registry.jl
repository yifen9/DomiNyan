module Registry

export REGISTRY, set!, get, @register

const REGISTRY = Dict{Symbol, Function}()

"""
    set!(key::Symbol, fn::Function)

Register an effect implementation under `key`.
"""
set!(key::Symbol, fn::Function) = (REGISTRY[key] = fn)

"""
    get(key::Symbol) -> Function

Retrieve a registered effect; throw if missing.
"""
get(key::Symbol) = Base.get(REGISTRY, key) do
    error("Effect $(key) not found in registry.")
end

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

end # module