module Registry

export STRATEGIES, set!, get, list, list_by_category, @register

# Mapping: strategy name ⇒ (fn, category)
const STRATEGIES = Dict{Symbol, Tuple{Function, Symbol}}()

"""
    set!(name, fn; category = :generic)

Register strategy `fn` under `name` with optional `category`.
"""
function set!(
    name::Symbol,
    fn::Function;
    category::Symbol = :generic
)
    STRATEGIES[name] = (fn, category)
    return nothing
end

"""
    get(name) -> Function

Retrieve the strategy function registered under `name`.
"""
function get(name::Symbol)::Function
    return STRATEGIES[name][1]
end

"""
    get_category(name) -> Symbol

Retrieve the category of the strategy `name`.
"""
get_category(name::Symbol)::Symbol = STRATEGIES[name][2]

"""
    list() -> Vector{Symbol}

List all registered strategy names.
"""
list()::Vector{Symbol} = collect(keys(STRATEGIES))

"""
    list_by_category(cat) -> Vector{Symbol}

List all strategies in category `cat`.
"""
function list_by_category(cat::Symbol)::Vector{Symbol}
    return [n for (n, (_, c)) in STRATEGIES if c == cat]
end

"""
    @register name fn [category]

Macro to register a strategy at parse time.
Usage:
```julia
@register :random random_choice :card
If category omitted, defaults to :generic.
"""
macro register(name, fn, category=:generic)
    return
        quote
            Registry.set!($(esc(name)), $(esc(fn));
            category=$(esc(category)))
        end
    end

end # module Registry