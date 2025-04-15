module Action

export run!

using ....State
using ....Logger
using ....Choose

using .....Play
using .....Cards

function run!(game::State.Game, log::Logger.Log)
    player = game.players[game.player_current]

    strategy = Choose.strategy_get(:card_action_default)

    while player.action > 0
        card = strategy(player, game)
        if card === nothing
            break
        end

        # 日志记录
        Logger.push!(log, :CardPlay; data=Dict(
            :card_target => Cards.Registry.get_name(card),
            :player => game.player_current,
            :card_count => 1,
        ))

        play_func = Cards.Registry.get_play(card)
        play_func(card, player, game)

        # 放入已打出区
        Base.push!(player.played, card)
        idx = findfirst(==(card), player.hand)
        if idx !== nothing
            deleteat!(player.hand, idx)
        end

        player.action -= 1
    end

    return nothing
end

end