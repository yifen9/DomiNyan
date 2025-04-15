import ..Loader: fields_register

fields_register(["game_id"])

Registry.set_many!([
    (:GameStart,  "game_start",  :game, [:game_id]),
    (:GameEnd,    "game_end",    :game, [:game_id]),
    (:GamePulse,  "game_pulse",  :game, [:game_id]),
    (:GameResume, "game_resume", :game, [:game_id]),
])