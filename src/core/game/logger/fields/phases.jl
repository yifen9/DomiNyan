import ..Loader: fields_register

fields_register(["phase"])

Registry.set_many!([
    (:PhaseStart, "PHASE_START",  :phase, [:phase]),
    (:PhaseEnd,   "PHASE_END",    :phase, [:phase]),
])