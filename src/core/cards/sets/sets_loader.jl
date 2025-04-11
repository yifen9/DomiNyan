const ENABLED_SETS = ["base", "intrigue"]

function load_selected_sets()
    for set in ENABLED_SETS
        for file in sort(readdir(joinpath(@__DIR__,set)))
            if endswith(file, ".jl")
                include(joinpath(set, file))
            end
        end
    end
end

load_selected_sets()