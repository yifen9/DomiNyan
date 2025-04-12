struct Gold <: Types.CardTreasure
    cost::Int
    coin::Int
end

function gold_play!(card::Gold, player, game)
    Effects.Registry.get("coin_gain")(player, card.coin)
end

set("Gold",
    () -> Gold(6, 3),
    gold_play!
)