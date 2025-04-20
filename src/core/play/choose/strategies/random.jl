function random!(items, n::Int=1)
    return n == 1 ? Utils.Common.pick_one(items) : Utils.Common.pick_n(items, n)
end

@register :random random! :generic