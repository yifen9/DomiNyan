function card_gain!(
    _card_source::Types.CardTemplate,
    pl::Player.State,
    _game,
    card_target::Types.CardAbstract
)
    push!(pl.discard, card_target)
    return (; card_gain = card_target)
end

@register :card_gain card_gain!