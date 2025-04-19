module Player

export State, new,
       deck_size, hand_size, played_size, discard_size

using Random: shuffle!

using ..Types

# --------------------------------------------------------------
# State : runtime snapshot of a Dominion player
# --------------------------------------------------------------
mutable struct State
    deck::Vector{Types.CardAbstract}      # draw pile (top = first element)
    hand::Vector{Types.CardAbstract}      # cards in hand
    played::Vector{Types.CardAbstract}    # played cards this turn
    discard::Vector{Types.CardAbstract}   # discard pile
    action::Int                           # remaining actions
    coin::Int                             # coins in treasure pool
    buy::Int                              # remaining buys
end

# ----------------------------------------------------------------
# Constructor
# ----------------------------------------------------------------
"""
    new(deck_starting; shuffle_deck = true) -> State

Create a fresh player `State` from an initial deck vector.

* `deck_starting` — vector of cards that form the initial draw pile.
* `deck_shuffle`  — whether to shuffle that deck before play (default = `true`).

The function leaves the hand, discard, and played piles empty and sets
`action = 1`, `coin = 0`, `buy = 1` (Dominion standard).
"""
function new(deck_starting::Vector{<:Types.CardAbstract}; deck_shuffle::Bool = true)
    deck = deck_shuffle ? shuffle!(copy(deck_starting)) : copy(deck_starting)
    return State(
        deck,                      # deck (top = first element)
        Types.CardAbstract[],      # hand
        Types.CardAbstract[],      # played
        Types.CardAbstract[],      # discard
        1, 0, 1                    # actions, coins, buys
    )
end

# -------- simple getters (noun first) -----------------------
deck_size(pl::State)    = length(pl.deck)
hand_size(pl::State)    = length(pl.hand)
played_size(pl::State)  = length(pl.played)
discard_size(pl::State) = length(pl.discard)

end # module