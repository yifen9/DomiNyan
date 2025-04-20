import ..Loader: fields_register

fields_register([:phase])

Registry.set_many!([
    (:PhaseStart, "phase_start",  :phase, [:phase]),
    (:PhaseEnd,   "phase_end",    :phase, [:phase]),
])