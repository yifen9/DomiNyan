function buy_gain!(pl::Player.State, _game, n::Int = 1)
    pl.buy += n
    return (; buy_gain = n)
end

@register :buy_gain buy_gain!