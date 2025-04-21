function player_coin_gain!(
    _card_source::Types.CardTemplate,
    pl::Player.State,
    _game,
    n::Int = 1
)
    pl.coin += n
    return (; player_coin_gain = n)
end

@register :player_coin_gain player_coin_gain!