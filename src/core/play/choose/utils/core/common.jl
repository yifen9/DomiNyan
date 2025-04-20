module Common

export pick_one, pick_n

"""
    pick_one(items)

Return a random element from a non‑empty collection `items`.
"""
function pick_one(items)
    @assert !isempty(items) "Cannot pick_one from an empty collection"
    return items[rand(1:length(items))]
end

"""
    pick_n(items, n)

Return up to `n` distinct random elements from `items`.  
If `n ≥ length(items)`, returns a shuffled copy of `items`.
"""
function pick_n(items, n::Int)
    len = length(items)
    data = copy(items)
    shuffle!(data)
    return data[1:min(n, len)]
end

end # module Common