function action_gain!(player::Player.State, n::Int)
    player.action += n
end

Registry.set!("action_gain", action_gain!)