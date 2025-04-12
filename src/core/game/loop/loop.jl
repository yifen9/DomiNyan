module Loop

export game_start

include("phases/phases.jl")

using .Phases

using ..State
using ..Logger

using ...Play
using ...Cards

function turn_play!(game::State.Game, log)
    Phases.Start.run!(game, log)
    Phases.Action.run!(game, log)
    Phases.Buy.run!(game, log)
    Phases.Cleanup.run!(game, log)
end

function player_next!(game::State.Game)
    game.player_current = mod1(game.player_current + 1, length(game.players))
end

function is_game_over(game::State.Game)::Bool
    return game.supply["Province"] == 0 ||
        count(v -> v[2] == 0, collect(game.supply)) >= 3
end

function game_start(game::State.Game)
    log = Logger.init!(echo=true)

    for p in game.players
        Play.Effects.Registry.get("card_draw")(p, 5)
    end

    Logger.push!(log, :GameStart; data=Dict(:game_id => game.game_id))

    while !is_game_over(game)
        Logger.push!(log, :TurnStart; data=Dict(
            :turn => game.turn,
            :player => game.player_current,
        ))

        turn_play!(game, log)

        Logger.push!(log, :TurnEnd; data=Dict(
            :turn => game.turn,
            :player => game.player_current,
        ))

        game.turn += 1
        player_next!(game)
    end

    Logger.push!(log, :GameEnd; data=Dict(:game_id => game.game_id))
    Logger.export_all(log, game)
end

end