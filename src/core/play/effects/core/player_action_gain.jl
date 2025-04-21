function player_action_gain!(
    _card_source::Types.CardTemplate,
    pl::Player.State,
    _game,
    n::Int = 1
)
    pl.action += n
    return (; player_action_gain = n)
end

@register :player_action_gain player_action_gain!