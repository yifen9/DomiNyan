function card_discard!(
    _card_source::Types.CardTemplate,
    pl::Player.State,
    _game,
    card_target::Types.CardAbstract
)
    # 1) find index or throw
    idx = findfirst(==(card_target), pl.hand)
    # idx === nothing means “not found”
    if idx === nothing
        error("Card not in hand: $card_target")
    end

    # 2) remove from hand and push to discard pile
    card = splice!(pl.hand, idx)
    push!(pl.discard, card)

    # 3) return the discarded card
    return (; card_discard = card)
end

@register :card_discard card_discard!