module Loop

export game_start

using ..State

using ...Play
using ...Cards

function game_start(game::Game)
    while true
        player = game.players[game.player_current]

        println("===== 回合开始：玩家 $(game.player_current) =====")
        Play.Effects.Registry.get("draw_cards")(player, 5)

        # 简化处理：自动买铜牌
        if game.supply["Copper"] > 0
            push!(player.discard, Cards.Registry.get_field("Copper"))
            game.supply["Copper"] -= 1
            println("玩家 $(game.player_current) 购买了一张 Copper")
        end

        # 清理阶段
        append!(player.discard, player.hand)
        append!(player.discard, player.played)
        empty!(player.hand)
        empty!(player.played)

        # 切换玩家
        game.player_current = mod(game.player_current, length(game.players)) + 1

        # 示例：暂时跑两轮就停
        if rand() < 0.1
            println("游戏结束")
            break
        end
    end
end

end