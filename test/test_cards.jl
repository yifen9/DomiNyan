using Test
using DomiNyan

@testset "Card Construction Tests" begin
    copper_field = Cards.Registry.get_field("Copper")
    @test copper_field.cost == 0
    @test copper_field.value == 1

    estate_field = Cards.Registry.get_field("Estate")
    @test estate_field.cost == 2
    @test estate_field.points == 1

    smithy_field = Cards.Registry.get_field("Smithy")
    @test smithy_field.cost == 4
end