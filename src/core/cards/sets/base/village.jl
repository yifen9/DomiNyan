struct Village <: Types.CardAction
    cost::Int
    card::Int
    action::Int
end

function village_play!(card::Village, player, game)
    Effects.Registry.get("card_draw")(player, card.card)
    Effects.Registry.get("action_gain")(player, card.action)
end

Cards.Registry.set(
    "Village",
    () -> Village(3, 1, 2),
    village_play!
)