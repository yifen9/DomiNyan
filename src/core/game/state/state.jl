module State

export Game, game_new

using ...Play
using ...Cards

mutable struct Game
    players::Vector{Play.Player.State}
    supply::Dict{String, Int}
    player_current::Int
end

function game_new()
    copper = Cards.Registry.get_field("Copper")
    estate = Cards.Registry.get_field("Estate")

    # 每人起始牌堆
    player1 = Play.Player.new(vcat(fill(copper, 7), fill(estate, 3)))
    player2 = Play.Player.new(vcat(fill(copper, 7), fill(estate, 3)))

    game = Game([player1, player2], Dict("Copper" => 60, "Estate" => 8), 1)
    return game
end

end