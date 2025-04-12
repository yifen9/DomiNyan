function gain_cards!(player::State, card::Card)
    push!(player.discard, card)
end

set!("gain_cards", gain_cards!)