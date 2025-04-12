function card_gain!(player::State, card::Card)
    push!(player.discard, card)
end

set!("card_gain", card_gain!)