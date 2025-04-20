@register :Market Play.Types.Action(
    "Market";
    cost = 5,
    card_draw = 1,
    player_action_gain = 1,
    player_buy_gain = 1,
    player_coin_gain = 1,
    effects = [
        :card_draw,
        :player_action_gain,
        :player_buy_gain,
        :player_coin_gain
    ]
)