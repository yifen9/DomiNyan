struct Woodcutter <: Types.CardAction
    cost::Int
    buy::Int
    coin::Int
end

function market_play!(card::Woodcutter, player, game)
    Effects.Registry.get("buy_gain")(player, card.buy)
    Effects.Registry.get("coin_gain")(player, card.coin)
end

set("Woodcutter",
    () -> Woodcutter(3, 1, 2),
    market_play!
)