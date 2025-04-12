module Registry

export REGISTRY, set!, get

import Base: get

const REGISTRY = Dict{String, Function}()

function set!(name::String, fn::Function)
    REGISTRY[name] = fn
end

function get(name::String)::Function
    return get(REGISTRY, name) do
        error("Effect $name not found in registry.")
    end
end

end