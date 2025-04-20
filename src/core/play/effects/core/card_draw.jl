using Random: shuffle!

function card_draw!(
    _card_source::Types.CardTemplate,
    pl::Player.State,
    _game,
    n::Int
)
    drawn = 0
    for _ in 1:n
        isempty(pl.deck) && !isempty(pl.discard) && begin
            pl.deck = shuffle!(copy(pl.discard)); empty!(pl.discard)
        end
        isempty(pl.deck) && break
        push!(pl.hand, popfirst!(pl.deck))
        drawn += 1
    end
    return (; card_draw = drawn)
end

@register :card_draw card_draw!