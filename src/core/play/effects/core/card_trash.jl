function card_trash!(player::State, card::Card, game)
    index = findfirst(==(card), player.hand)
    if isnothing(index)
        error("Card not found in hand")
    end

    deleteat!(player.hand, index)
    push!(game.trash, card)
end

set!("card_trash", card_trash!)