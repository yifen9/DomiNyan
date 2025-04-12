struct Festival <: Types.CardAction
    cost::Int
    action::Int
    buy::Int
    coin::Int
end

function festival_play!(card::Festival, player)
    Effects.Registry.get("action_gain")(player, card.action)
    Effects.Registry.get("buy_gain")(player, card.buy)
    Effects.Registry.get("coin_gain")(player, card.coin)
end

Cards.Registry.set(
    "Festival",
    () -> Festival(5, 2, 1, 2),
    festival_play!
)