module Registry

export REGISTRY, set!, get

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

end # module