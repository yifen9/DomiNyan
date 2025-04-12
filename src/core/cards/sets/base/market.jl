struct Market <: Types.CardAction
    cost::Int
    card::Int
    action::Int
    buy::Int
    coin::Int
end

function market_play!(card::Market, player, game)
    Effects.Registry.get("card_draw")(player, card.card)
    Effects.Registry.get("action_gain")(player, card.action)
    Effects.Registry.get("buy_gain")(player, card.buy)
    Effects.Registry.get("coin_gain")(player, card.coin)
end

Cards.Registry.set(
    "Market",
    () -> Market(5, 1, 1, 1, 1),
    market_play!
)