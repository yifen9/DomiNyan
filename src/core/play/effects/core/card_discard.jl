function card_discard!(player::Player.State, card::Types.Card)
    index = findfirst(==(card), player.hand)
    if isnothing(index)
        error("Card not in hand")
    end
    push!(player.discard, card)
    deleteat!(player.hand, index)
    return Dict("card_discard" => card)
end

Registry.set!("card_discard", card_discard!)