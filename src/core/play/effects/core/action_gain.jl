function action_gain!(pl::Player.State, _game, n::Int = 1)
    pl.action += n
    return (; action_gain = n)
end

@register :action_gain action_gain!