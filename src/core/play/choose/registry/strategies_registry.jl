module Registry

export STRATEGIES, set!, get, exists, list, @register

# Mapping: strategy name ⇒ (fn, category)
const STRATEGIES = Dict{Symbol, Function}()

"""
    set!(name, fn)

Register strategy `fn` under `name`.
"""
function set!(
    name::Symbol,
    fn::Function
)
    STRATEGIES[name] = fn
    return nothing
end

"""
    get(name) -> Function

Retrieve the strategy function registered under `name`.
"""
function get(name::Symbol)::Function
    return STRATEGIES[name]
end

"""
    exists(key) -> Bool

Check whether `key` is registered.
"""
exists(key::Symbol) = haskey(STRATEGIES, key)

"""
    list() -> Vector{Symbol}

List all registered strategy names.
"""
list()::Vector{Symbol} = collect(keys(STRATEGIES))

"""
    @register name fn

Macro to register a strategy at parse time.
Usage:
```julia
@register :random random_choice
"""
macro register(sym, fn)
    return quote
        if exists($(esc(sym)))
            @warn "Strategy $(string($(esc(sym)))) is being overwritten."
        end
        set!($(esc(sym)), $(esc(fn)))
    end
end

end # module Registry