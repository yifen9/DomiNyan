struct Copper <: Types.CardTreasure
    cost::Int
    coin::Int
end

function copper_play!(card::Copper, player, game)
    Effects.Registry.get("coin_gain")(player, card.coin)
end

set("Copper",
    () -> Copper(0, 1),
    copper_play!
)