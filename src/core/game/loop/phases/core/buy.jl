module Buy

export run!

using ....State
using ....Logger
using ....Choose

using .....Play
using .....Cards

function card_buy_choose(player::Play.Player.State, game::State.Game)
    affordable = filter(kv -> kv[2] > 0 && Cards.Registry.get_field(kv[1]).cost <= player.coin, game.supply)

    return isempty(affordable) ? nothing : first(keys(affordable))
end

function run!(game::State.Game, log::Logger.Log)
    player = game.players[game.player_current]

    Logger.push!(log, :PhaseStart; data=Dict(:phase => "buy"))

    treasures = filter(c -> c isa Cards.Types.CardTreasure, player.hand)
    for card in treasures
        player.coin += card.coin
        Base.push!(player.played, card)
        deleteat!(player.hand, findfirst(==(card), player.hand))

        Logger.push!(log, :CardPlay; data=Dict(
            :card_target => Cards.Registry.get_name(card),
            :card_count => 1,
            :player => game.player_current,
            :phase => :buy,
        ))
    end

    strategy = Choose.strategy_get(:card_buy_default)

    while player.buy > 0
        card_name = strategy(player, game)
        if card_name === nothing
            break
        end

        # 从供应区扣除
        game.supply[card_name] -= 1

        # 放入弃牌堆
        card = Cards.Registry.get_field(card_name)
        Base.push!(player.discard, card)

        # 日志记录
        Logger.push!(log, :CardBuy; data=Dict(
            :card_target => card_name,
            :player => game.player_current,
            :card_count => 1,
        ))

        player.coin -= card.cost
        player.buy -= 1
    end

    Logger.push!(log, :PhaseEnd; data=Dict(:phase => "buy"))

    return nothing
end

end