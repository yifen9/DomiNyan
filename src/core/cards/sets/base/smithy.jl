struct Smithy <: Types.CardAction
    cost::Int
    card::Int
end

function smithy_play!(card::Smithy, player, game)
    Effects.Registry.get("card_draw")(player, card.card)
end

set("Smithy",
    () -> Smithy(4, 3),
    smithy_play!
)