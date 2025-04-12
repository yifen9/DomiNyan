module Effects

export load_all!, Registry

include("registry/registry.jl")

using .Registry

using ..Types
using ..Player

function load_all!()
    core_dir = normpath(joinpath(@__DIR__, "core"))
    for file in sort(readdir(core_dir))
        if endswith(file, ".jl")
            include(joinpath("core", file))
        end
    end
end

load_all!()

end