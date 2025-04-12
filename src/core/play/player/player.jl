module Player

export State, new

using ..Types

mutable struct State
    hand::Vector{Types.Card}
    deck::Vector{Types.Card}
    discard::Vector{Types.Card}
    played::Vector{Types.Card}
    action::Int
    coin::Int
    buy::Int
end

function new(deck::Vector{<:Types.Card})::State
    return State(Types.Card[], deck, Types.Card[], Types.Card[], 1, 0, 1)
end

end