module Registry

export REGISTRY, set!, set_many!, get_name, get_fields, types_all, get_by_name

const REGISTRY = Dict{Symbol, Tuple{String, Symbol, Vector{Symbol}}}()

function set!(sym::Symbol, name::String, category::Symbol, fields::Vector{Symbol})
    REGISTRY[sym] = (name, category, fields)
end

function set_many!(entries::Vector{Tuple{Symbol, String, Symbol, Vector{Symbol}}})
    for entry in entries
        set!(entry...)
    end
end

function get_name(sym::Symbol)::String
    return get(REGISTRY, sym, ("", :unknown, []))[1]
end

function get_category(sym::Symbol)::Symbol
    return get(REGISTRY, sym, ("", :unknown, []))[2]
end

function get_fields(sym::Symbol)::Vector{Symbol}
    return get(REGISTRY, sym, ("", :unknown, []))[3]
end

function get_by_name(name::String)::Union{Symbol, Nothing}
    for (sym, (n, _, _)) in REGISTRY
        if n == name
            return sym
        end
    end
    return nothing
end

end