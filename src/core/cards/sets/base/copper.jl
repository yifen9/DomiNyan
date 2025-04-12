struct Copper <: Types.CardTreasure
    cost::Int
    coin::Int
end

function copper_play!(card::Copper, player)
    Effects.Registry.get("coin_gain")(player, card.coin)
end

Cards.Registry.set(
    "Copper",
    () -> Copper(0, 1),
    copper_play!
)