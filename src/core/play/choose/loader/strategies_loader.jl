module Loader

export load_strategies!

using ..Registry  # import STRATEGIES, set!, get, list
using ..Utils

"""
    load_strategies!()

Dynamically include every `.jl` under `strategies/` so that
all strategy functions register themselves via the macro.
"""
function load_strategies!()
    dir_strat = normpath(joinpath(@__DIR__, "..", "strategies"))
    for file in sort(readdir(dir_strat; join=true))
        endswith(file, ".jl") && include(file)
    end
    return nothing
end

# upon module load, immediately pull in all strategies
load_strategies!()

end # module Loader