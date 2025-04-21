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

            # 2) discard each chosen card in turn
            Play.Effects.Pipeline.Step(
                :card_discard;
                # for iteration i, take the i‑th chosen card as single argument
                args      = (res, _cs, pl, _game, _out, i) -> (res[:chosen][:choose_discard][i],),
                # only run if there was at least one chosen
                condition = (res, _cs, pl, _game)    -> !isempty(res[:chosen]),
                # keep looping while we haven’t processed all chosen cards
                loop      = (res, _cs, pl, _game, _out, i) -> i < length(res[:chosen])
            ),

            # 3) draw as many cards as were discarded
            Play.Effects.Pipeline.Step(
                :card_draw;
                # draw count = number of discarded (length of chosen)
                args = (_res, _cs, pl, _game, _out, _i) -> (length(_res[:chosen]),)
            )
        ],
        returns = [:chosen]   # expose the list of discarded cards
    ),

    effects = [
        :player_action_gain,
        :pipeline
    ]
)