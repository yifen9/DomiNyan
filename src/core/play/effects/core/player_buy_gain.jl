function player_buy_gain!(
    _card_source::Types.CardTemplate,
    pl::Player.State,
    _game,
    n::Int = 1
)
    pl.buy += n
    return (; player_buy_gain = n)
end

@register :player_buy_gain player_buy_gain!