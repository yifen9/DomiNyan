import ..Loader: fields_register

fields_register(["turn", "player"])

Registry.set_many!([
    (:TurnStart, "TURN_START", :turn, [:turn, :player]),
    (:TurnEnd,   "TURN_END",   :turn, [:turn, :player]),
])