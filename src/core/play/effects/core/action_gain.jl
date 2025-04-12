function action_gain!(player::Player.State, card::Types.Card)
    player.action += Card.action
end

Registry.set!("action_gain", action_gain!)