using Test
using DomiNyan

@testset "Strategy Registry" begin
    Game.Choose.strategy_set!(:dummy, x -> x + 1)
    f = Game.Choose.strategy_get(:dummy)
    @test f(10) == 11

    @test Game.Choose.strategy_get(:nonexistent) === nothing
end

@testset "Game Loop" begin
    game = Game.State.game_new(4)
    @test length(game.players) == 4
    @test haskey(game.supply, "Copper")

    Game.Loop.game_start(game)
    @test game.player_current in 1:4
end