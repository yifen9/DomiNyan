struct Silver <: Types.CardTreasure
    cost::Int
    coin::Int
end

function silver_play!(card::Silver, player)
    Effects.Registry.get("coin_gain")(player, card.coin)
end

Cards.Registry.set(
    "Silver",
    () -> Silver(3, 2),
    silver_play!
)