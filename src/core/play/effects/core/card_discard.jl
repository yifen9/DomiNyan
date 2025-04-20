function card_discard!(
    card_source::Types.CardTemplate,
    pl::Player.State,
    game,
    card_targets::Union{Types.CardAbstract, AbstractVector{<:Types.CardAbstract}}
)
    # Normalize input into a vector of card targets
    targets = isa(card_targets, AbstractVector) ? card_targets : [card_targets]

    # Container for the actually discarded cards
    discarded = Types.CardAbstract[]

    for card_target in targets
        # Find the index of the target card in the player's hand
        idx = findfirst(==(card_target), pl.hand) || error("Card not in hand: $card_target")
        # Remove it from hand and append to discard pile
        c = splice!(pl.hand, idx)
        push!(pl.discard, c)
        push!(discarded, c)
    end

    # Return a named tuple: card_discard for single, card_discards for multiple
    if length(discarded) == 1
        return (; card_discard = discarded[1])
    else
        return (; card_discards = discarded)
    end
end

@register :card_discard card_discard!