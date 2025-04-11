struct Smithy <: CardAction
    cost::Int
end

set("Smithy", () -> Smithy(4), (card, player, game) -> Play.Effects.draw_cards!(player, 3))