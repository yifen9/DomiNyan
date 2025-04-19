function card_gain!(pl::Player.State, _game, card::Types.CardAbstract)
    push!(pl.discard, card)
    return (; card_gain = card)
end

@register :card_gain card_gain!