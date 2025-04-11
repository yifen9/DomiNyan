module Player

using ..Types

export PlayerState, player_new, cards_draw!, cards_discard!, cards_gain!, cards_play!

struct PlayerState
    hand::Vector{Card}
    deck::Vector{Card}
    discard::Vector{Card}
    played::Vector{Card}
    actions::Int
    coins::Int
    buys::Int
end

function player_new(deck::Vector{Card})::PlayerState
    shuffle!(deck)
    hand = Card[]
    discard = Card[]
    played = Card[]
    player = PlayerState(hand, deck, discard, played, 1, 0, 1)
    cards_draw!(player, 5)
    return player
end

function cards_draw!(player::PlayerState, n::Int)
    for _ in 1:n
        if isempty(player.deck)
            if isempty(player.discard)
                break
            else
                # Reshuffle discard into deck
                player.deck = shuffle!(copy(player.discard))
                empty!(player.discard)
            end
        end
        push!(player.hand, popfirst!(player.deck))
    end
end

function cards_remove_from!(cards::Vector{Card}, card::Card)
    idx = findfirst(isequal(card), cards)
    isnothing(idx) && error("Card not found in collection")
    deleteat!(cards, idx)
end

function cards_discard!(player::PlayerState, card::Card)
    cards_remove_from!(player.hand, card)
    push!(player.discard, card)
end

function cards_play!(player::PlayerState, card::Card)
    cards_remove_from!(player.hand, card)
    push!(player.played, card)
end

function cards_gain!(player::PlayerState, card::Card)
    push!(player.discard, card)
end

end