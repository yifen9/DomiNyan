module Phases

export register!, name_get

const REGISTRY = Dict{Symbol, String}()

function register!(sym::Symbol, name::String)
    REGISTRY[sym] = name
end

function name_get(sym::Symbol)::String
    return get(REGISTRY, sym) do
        error("Unknown phase: $sym")
    end
end

register!(:PhaseStart, "START")
register!(:PhaseAction, "ACTION")
register!(:PhaseBuy, "BUY")
register!(:PhaseCleanup, "CLEANUP")

end