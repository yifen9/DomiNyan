using Test
using DomiNyan

@testset "Game Loop" begin
    game = Game.State.game_new()
    @test length(game.players) == 2
    @test haskey(game.supply, "Copper")

    Game.Loop.game_start(game)
    @test game.player_current in (1, 2)
end