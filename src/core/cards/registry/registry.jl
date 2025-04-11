module Registry

export CARD_REGISTRY, card_set, card_get

const CARD_REGISTRY = Dict{Any, Tuple{DataType, Function}}()

function card_set(name::String, constructor::Any, play_function::Function)
    CARD_REGISTRY[name] = (constructor, play_function)
end

function card_get(name::String)
    haskey(CARD_REGISTRY, name) || error("Card '$name' not found. Available: $(keys(CARD_REGISTRY))")

    constructor, play_function = CARD_REGISTRY[name]

    return constructor(), play_function
end

end