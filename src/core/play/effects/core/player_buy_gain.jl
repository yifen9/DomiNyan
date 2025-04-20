function buy_gain!(
    _card_source::Types.CardTemplate,
    pl::Player.State,
    _game,
    n::Int = 1
)
    pl.buy += n
    return (; buy_gain = n)
end

@register :buy_gain buy_gain!