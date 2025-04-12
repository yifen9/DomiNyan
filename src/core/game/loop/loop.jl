module Loop

export game_start

include("phases/phases.jl")

using .Phases

using ..State
using ..Logger

using ...Play
using ...Cards

function turn_play!(game::State.Game, log)
    State.set_phase!(game, "start")
    Logger.push!(log, :PhaseStart; data=Dict(:phase => game.phase))
    Phases.Start.run!(game, log)
    Logger.push!(log, :PhaseEnd; data=Dict(:phase => game.phase))

    State.set_phase!(game, "action")
    Logger.push!(log, :PhaseStart; data=Dict(:phase => game.phase))
    Phases.Action.run!(game, log)
    Logger.push!(log, :PhaseEnd; data=Dict(:phase => game.phase))

    State.set_phase!(game, "buy")
    Logger.push!(log, :PhaseStart; data=Dict(:phase => game.phase))
    Phases.Buy.run!(game, log)
    Logger.push!(log, :PhaseEnd; data=Dict(:phase => game.phase))

    State.set_phase!(game, "cleanup")
    Logger.push!(log, :PhaseStart; data=Dict(:phase => game.phase))
    Phases.Cleanup.run!(game, log)
    Logger.push!(log, :PhaseEnd; data=Dict(:phase => game.phase))
end

function player_next!(game::State.Game)
    game.player_current = mod1(game.player_current + 1, length(game.players))
end

function is_game_over(game::State.Game)::Bool
    return game.supply["Province"] == 0 ||
        count(v -> v[2] == 0, collect(game.supply)) >= 3
end

function game_start(game::State.Game)
    log = Logger.init!(game=game)

    for p in game.players
        Play.Effects.Registry.get("card_draw")(p, 5)
    end

    Logger.push!(log, :GameStart; data=Dict(:game_id => game.game_id))

    while !is_game_over(game)
        State.set_phase!(game, "TURN")
        Logger.push!(log, :TurnStart; data=Dict(
            :turn => game.turn,
            :player => game.player_current,
        ))

        turn_play!(game, log)

        State.set_phase!(game, "TURN")
        Logger.push!(log, :TurnEnd; data=Dict(
            :turn => game.turn,
            :player => game.player_current,
        ))

        game.turn += 1
        player_next!(game)
    end

    State.set_phase!(game, "GAME")

    Logger.push!(log, :GameEnd; data=Dict(:game_id => game.game_id))
    Logger.export_all(log, game)
end

end