struct Smithy <: CardAction
    cost::Int
end

Smithy() = Smithy(4)

smithy_play!(card, player) = cards_draw!(player, 3)

card_set("Smithy", Smithy, smithy_play!)