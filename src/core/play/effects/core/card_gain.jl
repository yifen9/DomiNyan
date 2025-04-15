function card_gain!(player::Player.State, card::Types.Card)
    push!(player.discard, card)
    return Dict("card_gain" => card)
end

Registry.set!("card_gain", card_gain!)