struct Smithy <: CardAction
    cost::Int
end

card_set("Smithy", () -> Smithy(4), (_, player) -> draw_cards!(player, 3))