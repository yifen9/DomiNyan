module Registry

export FieldDef, REGISTRY, types_all,
       set!, set_many!, get_name, get_category, get_fields, get_by_name

"""
    FieldDef(name, category, fields)

Holds registration data for one event type.
"""
struct FieldDef
    name::String
    category::Symbol
    fields::Vector{Symbol}
end

# main registry: Symbol → FieldDef
const REGISTRY   = Dict{Symbol,FieldDef}()
# reverse index: name → Symbol
const NAME_INDEX = Dict{String,Symbol}()

"""
    set!(sym, name, category, fields)

Register a new FieldDef under `sym`.
"""
function set!(
    sym::Symbol,
    name::String,
    category::Symbol,
    fields::Vector{Symbol}
)
    REGISTRY[sym] = FieldDef(name, category, fields)
    NAME_INDEX[name] = sym
    return nothing
end

"""
    set_many!(entries)

Bulk register multiple `(sym,name,category,fields)` tuples.
"""
function set_many!(
    entries::Vector{Tuple{Symbol,String,Symbol,Vector{Symbol}}}
)
    for (sym,name,category,fields) in entries
        set!(sym,name,category,fields)
    end
    return nothing
end

"""
    get_name(sym) -> String

Return the registered name for `sym`, or error if missing.
"""
get_name(sym::Symbol) = haskey(REGISTRY,sym)
    ? REGISTRY[sym].name
    : error("Unknown registry symbol: $sym")

"""
    get_category(sym) -> Symbol

Return the registered category for `sym`.
"""
get_category(sym::Symbol) = haskey(REGISTRY,sym)
    ? REGISTRY[sym].category
    : error("Unknown registry symbol: $sym")

"""
    get_fields(sym) -> Vector{Symbol}

Return the registered fields for `sym`.
"""
get_fields(sym::Symbol) = haskey(REGISTRY,sym)
    ? REGISTRY[sym].fields
    : error("Unknown registry symbol: $sym")

"""
    types_all() -> Vector{Symbol}

Return a sorted list of all registered symbols.
"""
types_all() = sort(collect(keys(REGISTRY)))

"""
    get_by_name(name) -> Union{Symbol,Nothing}

Return the symbol registered under `name`, or `nothing`.
"""
get_by_name(name::String) = get(NAME_INDEX, name, nothing)

end # module Registry