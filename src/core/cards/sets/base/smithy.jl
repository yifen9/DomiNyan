struct Smithy <: Types.CardAction
    cost::Int
    card::Int
end

function smithy_play!(card::Smithy, player)
    Effects.Registry.get("card_draw")(player, card.card)
end

Cards.Registry.set(
    "Smithy",
    () -> Smithy(4, 3),
    smithy_play!
)