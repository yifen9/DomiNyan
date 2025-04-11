using Test
using DomiNyan.Cards

@testset "Card Construction Tests" begin
    copper = Copper()
    @test copper.cost == 0
    @test copper.value == 1

    estate = Estate()
    @test estate.cost == 2
    @test estate.points == 1

    smithy = Smithy()
    @test smithy.cost == 4
end