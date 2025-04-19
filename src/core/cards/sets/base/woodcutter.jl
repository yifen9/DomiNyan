@register :Woodcutter Play.Types.Action(
    "Woodcutter";
    cost = 3,
    buy_gain = 1,
    coin_gain = 2,
    effects = [
        :buy_gain,
        :coin_gain
    ]
)