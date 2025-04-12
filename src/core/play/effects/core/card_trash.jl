function card_trash!(player::State, card::Card)
    index = findfirst(==(card), player.hand)
    if isnothing(index)
        error("Card not in hand")
    end
    deleteat!(player.hand, index)
    # push!(player.trash, card)
end

set!("card_trash", card_trash!)