struct Smithy <: Types.CardAction
    cost::Int
end

set("Smithy", () -> Smithy(4), (card, player, game) -> Effects.Registry.get("draw_cards")(player, 3))