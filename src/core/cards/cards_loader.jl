const ENABLED_SETS = ["base", "intrigue"]

function load_selected_sets()
    sets_root = joinpath(@__DIR__, "sets")

    for set in ENABLED_SETS
        set_path = joinpath(sets_root, set)
        if isdir(set_path)
            for file in sort(readdir(set_path))
                if endswith(file, ".jl")
                    include(joinpath("sets", set, file))
                end
            end
        else
            @warn "Card set '$set' not found at $set_path"
        end
    end
end

load_selected_sets()