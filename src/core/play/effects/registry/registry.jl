module Registry

export set!, get, exists, @register

# ─────────────────────────────────────────────────────────────────────────────
# Store effect implementations
# ─────────────────────────────────────────────────────────────────────────────
const REGISTRY = Dict{Symbol,Function}()

"""
    set!(key, fn)

Register effect function `fn` under `key`.
"""
function set!(key::Symbol, fn::Function)
    REGISTRY[key] = fn
    return nothing
end

"""
    get(key) -> Function

Lookup a registered effect implementation.  
Throws an error if `key` is not found.
"""
get(key::Symbol) = Base.get(REGISTRY, key) do
    error("Effect $(key) not found in registry.")
end

"""
    exists(key) -> Bool

Check whether `key` is registered.
"""
exists(key::Symbol) = haskey(REGISTRY, key)

# ─────────────────────────────────────────────────────────────────────────────
# Macro for authors to register at compile time:
# Usage in an effect file:
#
#     @register :card_discard card_discard!
#
# If `sym` already exists it will be overwritten with a warning.
# ─────────────────────────────────────────────────────────────────────────────
macro register(sym, fn)
    return quote
        if exists($(esc(sym)))
            @warn "Effect $(string($(esc(sym)))) is being overwritten."
        end
        set!($(esc(sym)), $(esc(fn)))
    end
end

end # module