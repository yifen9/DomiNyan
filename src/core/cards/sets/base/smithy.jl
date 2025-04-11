struct Smithy <: CardAction
    cost::Int
end

Smithy() = Smithy(4)

register_card!("Smithy", Smithy, (card, player) -> cards_draw!(player, 3))