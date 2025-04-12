using Test
using DomiNyan

@testset "Game Loop" begin
    game = Game.State.game_new(4)
    @test length(game.players) == 4
    @test haskey(game.supply, "Copper")

    Game.Loop.game_start(game)
    @test game.player_current in 1:4
end