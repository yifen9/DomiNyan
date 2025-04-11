module Registry

export CARD_REGISTRY, card_set, card_get, card_get_field, card_get_play

struct CardRegistryEntry
    constructor::Any
    play_function::Function
end

const CARD_REGISTRY = Dict{String, CardRegistryEntry}()

function card_set(name::String, constructor::Any, play_function::Function)
    CARD_REGISTRY[name] = CardRegistryEntry(constructor, play_function)
end

function card_get(name::String)
    haskey(CARD_REGISTRY, name) || error("Card '$name' not found. Available: $(keys(CARD_REGISTRY))")

    entry = CARD_REGISTRY[name]

    return entry.constructor(), entry.play_function
end

function card_get_field(name::String)
    haskey(CARD_REGISTRY, name) || error("Card '$name' not found. Available: $(keys(CARD_REGISTRY))")

    return CARD_REGISTRY[name].constructor()
end

function card_get_play(name::String)
    haskey(CARD_REGISTRY, name) || error("Card '$name' not found. Available: $(keys(CARD_REGISTRY))")

    return CARD_REGISTRY[name].play_function
end

end