module Cards

export filter_by_type,
       list_name,
       positions_of,
       count, count_by_type,
       types_present,
       group_by_type, group_by_name,
       sort_by_name, sort_by_cost

# -------------------------------------------------------------------
# Basic selection helpers
# -------------------------------------------------------------------

"""
    filter_by_type(cards, t) -> Vector{Card}

Return all cards in `cards` whose `type` set contains symbol `t`.
"""
filter_by_type(cards, t::Symbol) =
    [c for c in cards if t in c.type]

"""
    list_name(cards) -> Vector{String}

Return a vector of `card.name` for each card in `cards`.
"""
list_name(cards) = getfield.(cards, :name)

"""
    positions_of(cards, sel) -> Vector{Int}

Return the indices of all occurrences of `sel` (by identity) in `cards`.
"""
function positions_of(cards, sel)
    return [i for (i, c) in enumerate(cards) if c === sel]
end

# -------------------------------------------------------------------
# Counting metrics
# -------------------------------------------------------------------

"""
    count(cards) -> Int

Return the total number of cards in `cards`.
"""
count(cards) = length(cards)

"""
    count_by_type(cards, t) -> Int

Return the number of cards in `cards` of type `t`.
"""
count_by_type(cards, t::Symbol) = length(filter_by_type(cards, t))

# -------------------------------------------------------------------
# Type inspection
# -------------------------------------------------------------------

"""
    types_present(cards) -> Set{Symbol}

Return the set of all card types present in `cards`.
"""
function types_present(cards)
    ts = Set{Symbol}()
    for c in cards
        union!(ts, c.type)
    end
    return ts
end

# -------------------------------------------------------------------
# Grouping utilities
# -------------------------------------------------------------------

"""
    group_by_type(cards) -> Dict{Symbol,Vector{Card}}

Group cards by each type they have, returning a map from type to
the list of cards of that type.
"""
function group_by_type(cards)
    groups = Dict{Symbol, Vector{typeof(cards[1])}}()
    for c in cards
        for t in c.type
            get!(groups, t, Vector{typeof(c)}()) |> push!(c)
        end
    end
    return groups
end

"""
    group_by_name(cards) -> Dict{String,Vector{Card}}

Group cards by their `name`, returning a map from name to
the list of cards sharing that name.
"""
function group_by_name(cards)
    groups = Dict{String, Vector{typeof(cards[1])}}()
    for c in cards
        get!(groups, c.name, Vector{typeof(c)}()) |> push!(c)
    end
    return groups
end

# -------------------------------------------------------------------
# Sorting utilities
# -------------------------------------------------------------------

"""
    sort_by_name(cards; rev=false) -> Vector{Card}

Return `cards` sorted alphabetically by their `name`.
Set `rev=true` for descending order.
"""
function sort_by_name(cards; rev::Bool=false)
    sort(cards; by = c->c.name, rev = rev)
end

"""
    sort_by_cost(cards; rev=false) -> Vector{Card}

Return `cards` sorted by their `cost` field.
Set `rev=true` for descending order.
"""
function sort_by_cost(cards; rev::Bool=false)
    sort(cards; by = c->c.cost, rev = rev)
end

end # module Cards