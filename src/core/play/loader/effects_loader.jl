module Effects

using ..Player: State

function local_load_all!()
    effects_path = normpath(joinpath(@__DIR__, "..", "effects"))
    for file in sort(readdir(effects_path))
        if endswith(file, ".jl")
            include(joinpath(effects_path, file))
        end
    end
end

function load_all!()
    local_load_all!()
end

export load_all!

export draw_cards!

end