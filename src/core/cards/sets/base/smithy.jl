struct Smithy <: CardAction
    cost::Int
end

Smithy() = Smithy(4)

card_set("Smithy", Smithy, (card, player) -> cards_draw!(player, 3))