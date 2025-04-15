function card_trash!(player::Player.State, card::Types.Card, game)
    index = findfirst(==(card), player.hand)
    if isnothing(index)
        error("Card not found in hand")
    end
    deleteat!(player.hand, index)
    push!(game.trash, card)
    return Dict("card_trash" => card)
end

Registry.set!("card_trash", card_trash!)