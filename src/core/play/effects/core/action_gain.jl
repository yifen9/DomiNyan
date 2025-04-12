function action_gain!(player::State, card::Card)
    player.action += Card.action
end

set!("action_gain", action_gain!)