module CardBuy

export default, expensive_first, victory_only

using ..Utils

using ....Play
using ....Cards

function default(player, game)
    cards = Utils.card_filter_affordable(game.supply, player.coin)
    return isempty(cards) ? nothing : first(cards)
end

function expensive_first(player, game)
    cards = Utils.card_filter_affordable(game.supply, player.coin)
    sorted = Utils.card_sort_by_cost(cards; rev=true)
    return isempty(sorted) ? nothing : first(sorted)
end

function victory_only(player, game)
    cards = Utils.card_filter_by_type(player.hand, Play.Types.CardVictory)
    return isempty(cards) ? nothing : first(cards)
end

end