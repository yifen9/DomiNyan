import ..Loader: fields_register

fields_register(["game_id"])

Registry.set_many!([
    (:GameStart,  "GAME_START",  :game, [:game_id]),
    (:GameEnd,    "GAME_END",    :game, [:game_id]),
    (:GamePulse,  "GAME_PULSE",  :game, [:game_id]),
    (:GameResume, "GAME_RESUME", :game, [:game_id]),
])