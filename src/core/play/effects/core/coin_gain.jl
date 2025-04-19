function coin_gain!(pl::Player.State, _game, n::Int = 1)
    pl.coin += n
    return (; coin_gain = n)
end

@register :coin_gain coin_gain!