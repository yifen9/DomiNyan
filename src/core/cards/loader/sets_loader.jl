using ...Play: Types, Effects

const SETS_ENABLED = ["base", "intrigue"]

function sets_load_selected()

    sets_dir = normpath(joinpath(@__DIR__, "..", "sets"))
    for set in SETS_ENABLED
        set_path = joinpath(sets_dir, set)
        for file in sort(readdir(set_path))
            if endswith(file, ".jl")
                include(joinpath(set_path, file))
            end
        end
    end
end

sets_load_selected()