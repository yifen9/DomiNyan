function action_gain!(player::Player.State, n::Int)
    player.action += n
    return Dict("action_gain" => n)
end

Registry.set!("action_gain", action_gain!)