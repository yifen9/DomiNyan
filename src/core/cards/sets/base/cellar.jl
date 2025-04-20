@register :Cellar Play.Types.Action(
  "Cellar";
  cost = 2,
  # ^ pre-pipeline defines ^
  pipeline = Play.Effects.Pipeline.Pipeline(
    [
      # 1) choose discard
      Play.Effects.Pipeline.Step(
        :choose_discard,
        Dict(:min => 0, :max => :all),
        nothing,
        :chosen
      ),
      # 2) discard chosen cards
      Play.Effects.Pipeline.Step(
        :card_discard!,
        Dict(),
        (res, tpl, pl, gm)-> !isempty(res[:chosen]),  # if not chosen don't discard
        nothing
      ),
      # 3) draw cards based on number of cards discarded
      Play.Effects.Pipeline.Step(
        :card_draw,
        Dict(:count => :chosen),
        nothing,
        nothing
      ),
      # 4) +1 action
      Play.Effects.Pipeline.Step(
        :player_action_gain,
        Dict(:n => 1),
        nothing,
        nothing
      )
    ],
    # export “discarded count”
    [:chosen]
  )
)