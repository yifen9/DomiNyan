import ..Loader: fields_register

fields_register([:turn, :player])

Registry.set_many!([
    (:TurnStart, "turn_start", :turn,   [:turn, :player]),
    (:TurnEnd,   "turn_end",   :turn,   [:turn, :player]),
])