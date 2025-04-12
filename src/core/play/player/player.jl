module Player

export State, new

using ..Types

mutable struct State
    hand::Vector{Card}
    deck::Vector{Card}
    discard::Vector{Card}
    played::Vector{Card}
    action::Int
    coin::Int
    buy::Int
end

function new(deck::Vector{<:Card})::State
    return State(Card[], deck, Card[], Card[], 1, 0, 1)
end

end