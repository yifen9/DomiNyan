@register :Market Play.Types.Action(
    "Market";
    cost = 5,
    card_draw = 1,
    action_gain = 1,
    buy_gain = 1,
    coin_gain = 1,
    effects = [
        :card_draw,
        :action_gain,
        :buy_gain,
        :coin_gain
    ]
)