function card_discard!(pl::Player.State, _game, card::Types.CardAbstract)
    idx = findfirst(==(card), pl.hand) || error("Card not in hand")
    card = splice!(pl.hand, idx)          # remove first
    push!(pl.discard, card)               # then add to discard
    return (; card_discard = card)
end

@register :card_discard card_discard!