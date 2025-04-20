@register :Cellar Play.Types.Action(
    "Cellar";                     # card name
    cost = 2,                     # cost in coins
    player_action_gain = 1,       # grant +1 action immediately

    # pipeline for “discard any number → draw that many”
    pipeline = Play.Effects.Pipeline.Flow(
        [   # 1) ask the player to choose between 0 and all cards from hand
            Play.Effects.Pipeline.Step(
                :choose_discard;
                args       = (:hand , 0, :all),
                result_key = :chosen
            ),

            # 2) if any cards were chosen, discard them
            Play.Effects.Pipeline.Step(
                :card_discard;
                condition  = (res, card_source, pl, game) -> !isempty(res[:chosen])
            ),

            # 3) draw as many cards as were discarded
            Play.Effects.Pipeline.Step(
                :card_draw;
                args       = ((res -> length(res[:chosen])))
            )
        ],
        returns = [:chosen]   # expose the list of discarded cards
    )
)