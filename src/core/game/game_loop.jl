module GameLoop

using ..Player
using ..Cards
using ..CardsRegistry

export GameState, game_new, turn_run, player_current, player_next!

mutable struct GameState
    players::Vector{PlayerState}
    current::Int
    turn::Int
end

function game_new(player_decks::Vector{Vector{Card}})
    players = [player_new(deck) for deck in player_decks]
    return GameState(players, 1, 1)
end

function current_player(game::GameState)::PlayerState
    return game.players[game.current]
end

function next_player!(game::GameState)
    game.current = mod1(game.current + 1, length(game.players))
    game.turn += 1
end

function run_turn(game::GameState)
    player = current_player(game)

    println("----------")
    println("Turn $(game.turn) - Player $(game.current)")
    println("Hand: ", join([string(typeof(c)) for c in player.hand], ", "))

    # Try to find one action card and play it
    for card in player.hand
        if card isa CardAction
            println("Playing card: ", typeof(card))
            play_fn = card_get_play(string(typeof(card)))
            play_fn(card, player, game)
            cards_play!(player, card)
            break
        end
    end

    next_player!(game)
end

end