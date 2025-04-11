module Registry

export REGISTRY, set, get, get_field, get_play

struct Entry
    constructor::Function
    play_function::Function
end

const REGISTRY = Dict{String, Entry}()

function set(name::String, constructor::Function, play_function::Function)
    REGISTRY[name] = Entry(constructor, play_function)
end

exists(name::String) = haskey(REGISTRY, name)

function not_found(name::String)
    error("Card '$name' not found. Available cards: $(join(keys(REGISTRY), ", "))")
end

function get(name::String)
    exists(name::String) || not_found(name::String)

    entry = REGISTRY[name]

    return entry.constructor(), entry.play_function
end

function get_field(name::String)
    exists(name::String) || not_found(name::String)

    return REGISTRY[name].constructor()
end

function get_play(name::String)
    exists(name::String) || not_found(name::String)

    f = REGISTRY[name].play_function

    return (card, player) -> f(card, player, nothing)
end

end