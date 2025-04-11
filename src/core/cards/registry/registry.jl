module Registry

export REGISTRY, registry_set, registry_get, registry_get_field, registry_get_play

struct Entry
    constructor::Function
    play_function::Function
end

const REGISTRY = Dict{String, Entry}()

function registry_set(name::String, constructor::Function, play_function::Function)
    REGISTRY[name] = Entry(constructor, play_function)
end

exists(name::String) = haskey(REGISTRY, name)

function not_found(name::String)
    error("Card '$name' not found. Available cards: $(join(keys(REGISTRY), ", "))")
end

function registry_get(name::String)
    exists(name::String) || not_found(name::String)

    entry = REGISTRY[name]

    return entry.constructor(), entry.play_function
end

function registry_get_field(name::String)
    exists(name::String) || not_found(name::String)

    return REGISTRY[name].constructor()
end

function registry_get_play(name::String)
    exists(name::String) || not_found(name::String)

    return REGISTRY[name].play_function
end

end