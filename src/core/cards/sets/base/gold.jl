struct Gold <: Types.CardTreasure
    cost::Int
    coin::Int
end

function gold_play!(card::Gold, player)
    Effects.Registry.get("coin_gain")(player, card.coin)
end

Cards.Registry.set(
    "Gold",
    () -> Gold(6, 3),
    gold_play!
)