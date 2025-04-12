module Utils

export card_filter_by_type, card_filter_affordable, card_sort_by_cost, card_find_victory, card_find_treasure

using ....Cards

"""
从手牌中过滤出某个类型（如 CardAction）卡牌
"""
function card_filter_by_type(cards::Vector, ::Type{T}) where T
    return filter(c -> c isa T, cards)
end

"""
从供应区中筛选出可负担的卡牌
"""
function card_filter_affordable(supply::Dict{String, Int}, max_cost::Int)
    return [name for (name, count) in supply if count > 0 && Cards.Registry.get_field(name).cost ≤ max_cost]
end

"""
将卡牌名集合按花费升序/降序排序
"""
function card_sort_by_cost(cards::Vector{String}; rev::Bool = false)
    return sort(cards, by = Cards.Registry.get_cost, rev = rev)
end

"""
在卡牌集合中找第一张胜利卡
"""
function card_find_victory(cards::Vector{String})
    for name in cards
        card = Cards.Registry.get_field(name)
        if card isa Cards.CardVictory
            return name
        end
    end
    return nothing
end

"""
在卡牌集合中找第一张金钱卡
"""
function card_find_treasure(cards::Vector{String})
    for name in cards
        card = Cards.Registry.get_field(name)
        if card isa Cards.CardTreasure
            return name
        end
    end
    return nothing
end

end