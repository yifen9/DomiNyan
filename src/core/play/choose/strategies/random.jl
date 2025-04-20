@register :random function(items, n::Int=1)
    n == 1 ? pick_one(items) : pick_n(items, n)
end