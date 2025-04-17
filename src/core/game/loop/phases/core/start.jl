module Start

export run!

using ....State
using ....Logger

using .....Play
using .....Cards

function run!(game::State.Game, log::Logger.Log)
    player = game.players[game.player_current]

    player.action = 1
    player.buy = 1
    player.coin = 0

    return nothing
end

end