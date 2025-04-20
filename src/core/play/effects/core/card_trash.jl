function card_trash!(
    _card_source::Types.CardTemplate,
    pl::Player.State,
    game,
    card_target::Types.CardAbstract
)
    index = findfirst(==(card_target), pl.hand)
    if isnothing(index)
        error("Card not found in hand")
    end
    card_target = splice!(pl.hand, index); push!(game.trash, card_target)
    return (; card_trash = card_target)
end

@register :card_trash card_trash!