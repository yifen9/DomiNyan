module GameState

using ..Player
using ..Cards

export GameState, game_new, player_current, player_next!

struct GameState
    players::Vector{PlayerState}
    current::Int
    turn::Int
end

function game_new(player_decks::Vector{Vector{Card}})
    players = [player_new(deck) for deck in player_decks]
    return GameState(players, 1, 1)
end

function player_current(game::GameState)::PlayerState
    return game.players[game.current]
end

function player_next!(game::GameState)
    game.current = mod1(game.current + 1, length(game.players))
    game.turn += 1
end

end