struct Laboratory <: Types.CardAction
    cost::Int
    card::Int
    action::Int
end

function laboratory_play!(card::Laboratory, player, game)
    Effects.Registry.get("card_draw")(player, card.card)
    Effects.Registry.get("action_gain")(player, card.action)
end

set("Laboratory",
    () -> Laboratory(5, 2, 1),
    Laboratory_play!
)