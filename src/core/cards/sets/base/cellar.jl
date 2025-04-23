@register :Cellar Play.Types.Action(
    "Cellar";                              # card name
    cost = 2,                              # cost in coins
    player_action_gain = 1,                # +1 action

    # pipeline for “discard any number → draw that many”
    pipeline = Play.Effects.Pipeline.Flow(
        [
            # 1) ask the player to choose between 0 and all cards from hand
            Play.Effects.Pipeline.Step(
                :choose_discard;
                args = (:hand, 0, :all)
            ),

            # 2) discard each chosen card in turn
            Play.Effects.Pipeline.Step(
                :card_discard;
                args      = (res, _cs, _pl, _game, _out, i) ->
                                (res[:choose_discard][i],),
                condition = (res, _cs, _pl, _game) ->
                                !isempty(res[:choose_discard]),
                loop      = (res, _cs, _pl, _game, _out, i) ->
                                i < length(res[:choose_discard])
            ),

            # 3) draw as many cards as were discarded
            Play.Effects.Pipeline.Step(
                :card_draw;
                args      = (res, _cs, _pl, _game, _out, _i) ->
                                (length(res[:choose_discard]),),
                condition = (res, _cs, _pl, _game) ->
                                !isempty(res[:choose_discard])
            )
        ];
        # returns = [:chosen]                  # expose the chosen cards
    ),

    effects = [
        :player_action_gain,
        :pipeline
    ]
)