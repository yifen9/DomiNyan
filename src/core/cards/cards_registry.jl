module CardsRegistry

export CARD_REGISTRY, card_set, card_get, card_get_field, card_get_play

struct CardRegistryEntry
    constructor::Function
    play_function::Function
end

const CARD_REGISTRY = Dict{String, CardRegistryEntry}()

function card_set(name::String, constructor::Function, play_function::Function)
    CARD_REGISTRY[name] = CardRegistryEntry(constructor, play_function)
end

card_exists(name::String) = haskey(CARD_REGISTRY, name)

function _card_not_found(name::String)
    error("Card '$name' not found. Available cards: $(join(keys(CARD_REGISTRY), ", "))")
end

function card_get(name::String)
    card_exists(name::String) || _card_not_found(name::String)

    entry = CARD_REGISTRY[name]

    return entry.constructor(), entry.play_function
end

function card_get_field(name::String)
    card_exists(name::String) || _card_not_found(name::String)

    return CARD_REGISTRY[name].constructor()
end

function card_get_play(name::String)
    card_exists(name::String) || _card_not_found(name::String)

    return CARD_REGISTRY[name].play_function
end

end