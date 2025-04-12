function coin_gain!(player::State, card::Card)
    player.coin += Card.coin
end

set!("coin_gain", coin_gain!)