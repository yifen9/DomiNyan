using Test
using DomiNyan.Cards.CardRegistry

@testset "Card Registry Tests" begin
    @test haskey(CARD_REGISTRY, "Copper")
    @test haskey(CARD_REGISTRY, "Estate")
    @test haskey(CARD_REGISTRY, "Smithy")

    copper = card_get("Copper")
    estate = card_get("Estate")
    smithy = card_get("Smithy")

    @info "Copper card created" copper

    @test copper.cost == 0
    @test estate.points == 1
    @test smithy.cost == 4
end