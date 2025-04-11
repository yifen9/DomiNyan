using Test
using DomiNyan.Cards

@testset "Card Construction Tests" begin
    # copper = card_get("Copper")
    # @test copper.cost == 0
    # @test copper.value == 1

    # estate = card_get("Estate")
    # @test estate.cost == 2
    # @test estate.points == 1

    smithy = card_get("Smithy")
    @test smithy.cost == 4
end