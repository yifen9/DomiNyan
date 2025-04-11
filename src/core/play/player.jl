module Player

using ..Types

export PlayerState, player_new, draw_cards!, discard_cards!, gain_cards!, play_cards!

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

function draw_cards!(player::PlayerState, n::Int)
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

function remove_from!(cards::Vector{Card}, card::Card)
    idx = findfirst(isequal(card), cards)
    isnothing(idx) && error("Card not found in collection")
    deleteat!(cards, idx)
end

function discard_cards!(player::PlayerState, card::Card)
    remove_from!(player.hand, card)
    push!(player.discard, card)
end

function play_cards!(player::PlayerState, card::Card)
    remove_from!(player.hand, card)
    push!(player.played, card)
end

function gain_cards!(player::PlayerState, card::Card)
    push!(player.discard, card)
end

end