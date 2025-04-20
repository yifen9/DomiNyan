function action_gain!(
    _card_source::Types.CardTemplate,
    pl::Player.State,
    _game,
    n::Int = 1
)
    pl.action += n
    return (; action_gain = n)
end

@register :action_gain action_gain!