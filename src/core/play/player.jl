module Player

using ..Cards.types_Card
export PlayerState, player_new

struct PlayerState
    hand::Vector{types_Card}
    deck::Vector{types_Card}
    discard::Vector{types_Card}
    played::Vector{types_Card}
    actions::Int
    coins::Int
    buys::Int
end

function player_new(deck::Vector{types_Card})::PlayerState
    return PlayerState(types_Card[], deck, types_Card[], types_Card[], 1, 0, 1)
end

end