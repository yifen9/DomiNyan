module Player

export player_indices, players_other,
       deck, hand, played, discard,
       deck_size, hand_size, played_size, discard_size,
       actions_current, buys_current, coin_current,
       sort_players_by,
       sort_by_deck_size, sort_by_hand_size, sort_by_played_size, sort_by_discard_size,
       sort_by_actions_current, sort_by_buys_current, sort_by_coin_current

# -------------------------------------------------------------------
# Player‑state inspection helpers for choice strategies
# -------------------------------------------------------------------

"""
    player_indices(game) -> Vector{Int}

Return all player indices in the game.
"""
player_indices(game) = collect(1:length(game.players))

"""
    players_other(game) -> Vector{Int}

Return indices of all players except the current player.
"""
players_other(game) = filter(i -> i != game.player_current, player_indices(game))

# -------------------------------------------------------------------
# Access raw piles
# -------------------------------------------------------------------

"""
    deck(game, pid) -> Vector{Card}

Return the deck vector of player `pid`.
"""
deck(game, pid) = game.players[pid].deck

"""
    hand(game, pid) -> Vector{Card}

Return the hand vector of player `pid`.
"""
hand(game, pid) = game.players[pid].hand

"""
    played(game, pid) -> Vector{Card}

Return the played pile vector of player `pid`.
"""
played(game, pid) = game.players[pid].played

"""
    discard(game, pid) -> Vector{Card}

Return the discard pile of player `pid`.
"""
discard(game, pid) = game.players[pid].discard

# -------------------------------------------------------------------
# Simple numeric metrics
# -------------------------------------------------------------------

"""
    deck_size(game, pid) -> Int

Number of cards in player `pid`’s deck.
"""
deck_size(game, pid) = length(deck(game, pid))

"""
    hand_size(game, pid) -> Int

Number of cards in player `pid`’s hand.
"""
hand_size(game, pid) = length(hand(game, pid))

"""
    played_size(game, pid) -> Int

Number of cards in player `pid`’s played pile.
"""
played_size(game, pid) = length(played(game, pid))

"""
    discard_size(game, pid) -> Int

Number of cards in player `pid`’s discard pile.
"""
discard_size(game, pid) = length(discard(game, pid))

"""
    actions_current(game, pid) -> Int

Number of actions left for player `pid`.
"""
actions_current(game, pid) = game.players[pid].action

"""
    buys_current(game, pid) -> Int

Number of buys left for player `pid`.
"""
buys_current(game, pid) = game.players[pid].buy

"""
    coin_current(game, pid) -> Int

Current coin count for player `pid`.
"""
coin_current(game, pid) = game.players[pid].coin

# -------------------------------------------------------------------
# Sorting utilities
# -------------------------------------------------------------------

"""
    sort_players_by(game, key_fn; rev=false) -> Vector{Int}

Return the player indices sorted by `key_fn(game, pid)`.  
Set `rev=true` for descending order.
"""
function sort_players_by(game, key_fn::Function; rev::Bool=false)
    sort(
        player_indices(game);
        by = pid -> key_fn(game, pid),
        rev = rev
    )
end

"""
    sort_by_deck_size(game; rev=false) -> Vector{Int}

Sort players by deck size.
"""
sort_by_deck_size(game; rev::Bool=false) =
    sort_players_by(game, (g,p)->deck_size(g,p); rev=rev)

"""
    sort_by_hand_size(game; rev=false) -> Vector{Int}

Sort players by hand size.
"""
sort_by_hand_size(game; rev::Bool=false) =
    sort_players_by(game, (g,p)->hand_size(g,p); rev=rev)

"""
    sort_by_played_size(game; rev=false) -> Vector{Int}

Sort players by played pile size.
"""
sort_by_played_size(game; rev::Bool=false) =
    sort_players_by(game, (g,p)->played_size(g,p); rev=rev)

"""
    sort_by_discard_size(game; rev=false) -> Vector{Int}

Sort players by discard pile size.
"""
sort_by_discard_size(game; rev::Bool=false) =
    sort_players_by(game, (g,p)->discard_size(g,p); rev=rev)

"""
    sort_by_actions_current(game; rev=false) -> Vector{Int}

Sort players by remaining actions.
"""
sort_by_actions_current(game; rev::Bool=false) =
    sort_players_by(game, (g,p)->actions_current(g,p); rev=rev)

"""
    sort_by_buys_current(game; rev=false) -> Vector{Int}

Sort players by remaining buys.
"""
sort_by_buys_current(game; rev::Bool=false) =
    sort_players_by(game, (g,p)->buys_current(g,p); rev=rev)

"""
    sort_by_coin_current(game; rev=false) -> Vector{Int}

Sort players by coin total.
"""
sort_by_coin_current(game; rev::Bool=false) =
    sort_players_by(game, (g,p)->coin_current(g,p); rev=rev)

end # module Player