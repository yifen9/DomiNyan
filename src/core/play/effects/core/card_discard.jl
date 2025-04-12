function card_discard!(player::State, card::Card)
    index = findfirst(==(card), player.hand)
    if isnothing(index)
        error("Card not in hand")
    end
    push!(player.discard, card)
    deleteat!(player.hand, index)
end

set!("card_discard", card_discard!)