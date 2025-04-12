function card_gain!(player::Player.State, card::Types.Card)
    push!(player.discard, card)
end

Registry.set!("card_gain", card_gain!)