function card_discard!(player::Player.State, card::Types.Card)
    index = findfirst(==(card), player.hand)
    if isnothing(index)
        error("Card not in hand")
    end
    push!(player.discard, card)
    deleteat!(player.hand, index)
end

Registry.set!("card_discard", card_discard!)