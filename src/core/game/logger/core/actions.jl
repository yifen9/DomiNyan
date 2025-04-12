module Actions

export register!, name_get

const REGISTRY = Dict{Symbol, String}()

function register!(sym::Symbol, name::String)
    REGISTRY[sym] = name
end

function name_get(sym::Symbol)::String
    return get(REGISTRY, sym) do
        error("Unknown action: $sym")
    end
end

register!(:CardDraw, "CARD_DRAW")
register!(:CardBuy, "CARD_BUY")
register!(:CardPlay, "CARD_PLAY")
register!(:CardGain, "CARD_GAIN")
register!(:CardTrash, "CARD_TRASH")
register!(:TurnStart, "TURN_START")
register!(:GameEnd, "GAME_END")

end