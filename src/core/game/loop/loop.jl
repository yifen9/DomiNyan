module Loop

export game_start

using ..State
using ..Logger

using ...Play
using ...Cards

function game_start(game::Game)
    log = init!()
    turn = 1

    while true
        player_id = game.player_current
        player = game.players[player_id]

        Logger.turn!(log, player_id, turn)

        # === Phase: START ===
        Logger.action!(log, player_id, :TurnStart; phase = :PhaseStart, turn = turn)

        # === Phase: ACTION (略过具体 action 卡) ===
        Logger.action!(log, player_id, :CardDraw; phase = :PhaseAction, turn = turn)
        Play.Effects.Registry.get("card_draw")(player, 5)

        # === Phase: BUY ===
        if game.supply["Copper"] > 0
            push!(player.discard, Cards.Registry.get_field("Copper"))
            game.supply["Copper"] -= 1

            Logger.action!(
                log, player_id, :CardBuy;
                card = "Copper", phase = :PhaseBuy, turn = turn
            )
        end

        # === Phase: CLEANUP ===
        append!(player.discard, player.hand)
        append!(player.discard, player.played)
        empty!(player.hand)
        empty!(player.played)

        Logger.action!(log, player_id, :CardGain; card = "hand_all", phase = :PhaseCleanup, turn = turn)

        # 切换玩家
        next_player = Base.mod(player_id, length(game.players)) + 1
        game.player_current = next_player

        if rand() < 0.1
            Logger.action!(log, player_id, :GameEnd; turn = turn)
            break
        end

        @show turn
        turn += 1
    end

    Logger.export_all(log, game)
end

end