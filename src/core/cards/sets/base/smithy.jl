struct Smithy <: types_CardAction
    cost::Int
end

registry_set("Smithy", () -> Smithy(4), (_, player, game) -> effects_draw_cards!(player, 3))