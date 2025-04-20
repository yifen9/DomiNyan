module Loader

# ───────────────────────────
# Loader (idempotent)
# ───────────────────────────
using Dates: now

using ..Registry

using ...Types
using ...Player

const _core_loaded_at = Ref{Union{Nothing,Float64}}(nothing)

"""
    core_load!() -> Nothing

Include every `*.jl` in ./core **once**, unless the file set
or timestamps have changed.
"""
function core_load!()
    dir_core = normpath(joinpath(@__DIR__, "..", "core"))
    files = filter(f -> endswith(f, ".jl"), readdir(dir_core; join=true))
    isempty(files) && return nothing     # nothing to load
    change_last = maximum(stat(file).mtime for file in files)
    if !isnothing(_core_loaded_at[]) && _core_loaded_at[] ≥ change_last
        return nothing
    end
    for file in sort(files)
        include(file)
    end
    _core_loaded_at[] = change_last
    return nothing
end

core_load!()

end