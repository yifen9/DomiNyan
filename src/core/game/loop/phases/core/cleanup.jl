module Cleanup

export run!

using ....State
using ....Logger

using .....Play
using .....Cards

function run!(game::State.Game, log::Logger.Log)
    player = game.players[game.player_current]

    Logger.push!(log, :PhaseStart; data=Dict(:phase => "cleanup"))

    append!(player.discard, player.hand)
    empty!(player.hand)

    append!(player.discard, player.played)
    empty!(player.played)

    player.action = 0
    player.buy = 0
    player.coin = 0

    Play.Effects.Registry.get("card_draw")(player, 5)

    Logger.push!(log, :PhaseEnd; data=Dict(:phase => "cleanup"))

    return nothing
end

end