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

    Log.push!(log, :CardBuy; data=Dict(
        :card_target => card_name,
        :player => game.player_current,
        :card_count => 1,
    ))

    return nothing
end

end