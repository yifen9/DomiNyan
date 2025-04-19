function card_trash!(pl::Player.State, game, card::Types.CardAbstract)
    index = findfirst(==(card), pl.hand)
    if isnothing(index)
        error("Card not found in hand")
    end
    card = splice!(pl.hand, index); push!(game.trash, card)
    return (; card_trash = card)
end

@register :card_trash card_trash!