using Random: shuffle!

function card_draw!(
    _card_source::Types.CardTemplate,
    pl::Player.State,
    _game,
    n::Int
)
    # Initialize an empty vector to collect drawn cards
    drawn = Types.CardAbstract[]

    for _ in 1:n
        # If deck is empty but discard has cards, shuffle discard into deck
        isempty(pl.deck) && !isempty(pl.discard) && begin
            pl.deck = shuffle!(copy(pl.discard)); empty!(pl.discard)
        end

        # If deck is still empty, stop drawing
        isempty(pl.deck) && break

        # Draw the top card
        card = popfirst!(pl.deck)

        # Add it to hand and record it
        push!(pl.hand, card)
        push!(drawn, card)
    end
    return (; card_draw = drawn)
end

@register :card_draw card_draw!