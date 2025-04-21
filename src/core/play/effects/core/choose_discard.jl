"""
function choose_discard!(
    _card_source::Types.CardTemplate,
    pl::Player.State,
    _game,
    source::Symbol = :hand,
    min::Int = 0,
    max::Union{Int,Symbol} = :all
)::NamedTuple
    # 1) Fetch the pile (e.g. pl.hand, pl.discard, etc.)
    pile = getfield(pl, source)

    # 2) Compute the integer upper bound
    max_n = max === :all ? length(pile) : max

    # 3) Delegate to the choose interface (defaults to random strategy)
    selection = Choose.choose(:random, pile, min, max_n)

    # 4) Return the chosen cards under key `:chosen`
    return (; chosen = selection)
end
"""
function choose_discard!(
    _card_source::Types.CardTemplate,
    pl::Player.State,
    _game,
    source::Symbol = :hand,
    min::Int = 0,
    max::Union{Int,Symbol} = :all
)::NamedTuple
    return (; choose_discard = pl.hand[1:2])
end

@register :choose_discard choose_discard!