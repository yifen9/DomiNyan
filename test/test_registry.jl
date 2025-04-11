using DomiNyan.Cards.CardRegistry

@testset "Card registry" begin
    @test haskey(CARD_REGISTRY, "Copper")
    @test haskey(CARD_REGISTRY, "Estate")
    @test haskey(CARD_REGISTRY, "Smithy")

    card = get_card("Copper")
    @test card.value == 1
end