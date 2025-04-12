module CardGain

export default, victory_first, treasure_first, expensive_first

using ..Utils

using ....Play
using ....Cards

"""
默认策略：获得第一个可负担卡牌
"""
function default(player, game, max_cost::Int)
    cards = keys(Utils.card_filter_affordable(game.supply, max_cost))
    return isempty(cards) ? nothing : first(cards)
end

"""
优先获得胜利卡
"""
function victory_first(player, game, max_cost::Int)
    cards = keys(Utils.card_filter_affordable(game.supply, max_cost))
    return Utils.card_find_victory(collect(cards))
end

"""
优先获得金钱卡
"""
function treasure_first(player, game, max_cost::Int)
    cards = keys(Utils.card_filter_affordable(game.supply, max_cost))
    return Utils.card_find_treasure(collect(cards))
end

"""
优先获得最贵的卡
"""
function expensive_first(player, game, max_cost::Int)
    cards = collect(keys(Utils.card_filter_affordable(game.supply, max_cost)))
    sorted = Utils.card_sort_by_cost(cards; rev=true)
    return isempty(sorted) ? nothing : first(sorted)
end

end