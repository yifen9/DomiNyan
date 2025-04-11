export CARD_REGISTRY, card_register, card_get

const CARD_REGISTRY = Dict{String, Any}()

function card_register(name::String, constructor)
    CARD_REGISTRY[name] = constructor
end

function card_get(name::String)
    haskey(CARD_REGISTRY, name) || error("Card '$name' not found.")
    return CARD_REGISTRY[name]()
end