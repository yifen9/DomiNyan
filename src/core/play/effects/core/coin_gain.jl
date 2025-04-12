function coin_gain!(player::Player.State, card::Types.Card)
    player.coin += Card.coin
end

Registry.set!("coin_gain", coin_gain!)