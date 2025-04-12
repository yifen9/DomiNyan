function trash_cards!(player::State, card::Card)
    index = findfirst(==(card), player.hand)
    if isnothing(index)
        error("Card not in hand")
    end
    deleteat!(player.hand, index)
    # push!(player.trash, card)
end

set!("trash_cards", trash_cards!)