@register :Woodcutter Play.Types.Action(
    "Woodcutter";
    cost = 3,
    player_buy_gain = 1,
    player_coin_gain = 2,
    effects = [
        :player_buy_gain,
        :player_coin_gain
    ]
)