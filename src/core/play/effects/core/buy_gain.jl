function buy_gain!(player::Player.State, n::Int)
    player.buy += n
    return Dict("buy_gain" => n)
end

Registry.set!("buy_gain", buy_gain!)