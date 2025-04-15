function coin_gain!(player::Player.State, card::Types.Card)
    player.coin += card.coin
    return Dict("coin_gain" => card.coin)
end

Registry.set!("coin_gain", coin_gain!)