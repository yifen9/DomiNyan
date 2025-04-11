@testset "Card Construction" begin
    copper = Copper()
    @test copper.cost == 0
    @test copper.value == 1

    estate = Estate()
    @test estate.points == 1

    smithy = Smithy()
    @test smithy.cost == 4
end