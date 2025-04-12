module Fields

export register!, get, all

import Base: get

const REGISTRY = Dict{Symbol, String}()

function register!(sym::Symbol, field::String)
    REGISTRY[sym] = field
end

function get(sym::Symbol)::String
    return get(REGISTRY, sym) do
        error("Unknown field: $sym")
    end
end

function all()::Vector{String}
    return collect(values(REGISTRY))
end

register!(:turn, "turn")
register!(:phase, "phase")
register!(:card, "card")
register!(:timestamp, "timestamp")
register!(:type, "type")
register!(:player, "player")

end