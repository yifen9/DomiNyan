module CardAction

export default, aggressive, conservative

using ..Utils

using ....Play

function default(player, game)
    cards = Utils.card_filter_by_type(player.hand, Play.Types.CardAction)
    isempty(cards) ? nothing : @show first(cards)
    return isempty(cards) ? nothing : first(cards)
end

function aggressive(player, game)
    cards = Utils.card_filter_by_type(player.hand, Play.Types.CardAction)
    sorted = Utils.card_sort_by_cost(cards; rev=true)
    return isempty(sorted) ? nothing : first(sorted)
end

function conservative(player, game)
    cards = Utils.card_filter_by_type(player.hand, Play.Types.CardAction)
    sorted = Utils.card_sort_by_cost(cards)
    return isempty(sorted) ? nothing : first(sorted)
end

end