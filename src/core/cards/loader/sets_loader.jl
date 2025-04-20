# src/core/cards/loader/sets_loader.jl
module Loader

export sets_load!, set_list, set_cards

using ..Registry           # import Registry APIs
using ..Cards              # import the @register macro from parent

using ...Play

const _SETS_LOADED = Set{String}()

"Return a sorted `Vector{String}` of available set directories."
function set_list(dir_sets::AbstractString = joinpath(@__DIR__, "..", "sets"))
    filter(entry -> isdir(joinpath(dir_sets, entry)), readdir(dir_sets)) |> sort
end

"Return all `*.jl` files inside a set directory."
function set_cards(set_name::String; dir_sets::AbstractString = joinpath(@__DIR__, "..", "sets"))
    set_dir = joinpath(dir_sets, set_name)
    filter(f -> endswith(f, ".jl"), readdir(set_dir; join = true)) |> sort
end

"""
    sets_load!(; sets = ["base"], cards = nothing, dir_sets = default)

* `sets`  – Which set directories to load (default `["base"]`; `["*"]` for all).  
* `cards` – Optional `Vector{Symbol}`; if given, only these cards are loaded.
"""
function sets_load!(;
    sets::Vector{String}               = ["base"],
    cards::Union{Nothing,Vector{Symbol}} = nothing,
    dir_sets::AbstractString           = joinpath(@__DIR__, "..", "sets"))

    # wildcard → all sets
    sets = (sets == ["*"]) ? set_list(dir_sets) : sets

    # prepare a lowercase set of requested cards
    cards_lower = isnothing(cards) ? nothing :
                  Set(Symbol(lowercase(String(s))) for s in cards)

    for set in sets
        for file in set_cards(set; dir_sets = dir_sets)
            # filename without “.jl”, e.g. "copper" → :copper
            file_sym = Symbol(basename(file)[1:end-3])
            if isnothing(cards) || file_sym in cards_lower
                include(file)   # file must call @register
            end
        end
        push!(_SETS_LOADED, set)
    end
    return nothing
end

end # module Loader