module Cards

export filter_by_type, list_name, positions_of

"""
    filter_by_type(cards, t)

Return all cards in `cards` whose `type` set contains symbol `t`.
"""
filter_by_type(cards, t::Symbol) =
    [c for c in cards if t in c.type]

"""
    list_name(cards)

Return a `Vector{String}` of `card.name` for each card in `cards`.
"""
list_name(cards) = getfield.(cards, :name)

"""
    positions_of(cards, sel)

Return the indices of all occurrences of `sel` in `cards`.
"""
function positions_of(cards, sel)
    return [i for (i,c) in enumerate(cards) if c === sel]
end

end # module Cards