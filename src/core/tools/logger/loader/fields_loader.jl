module Loader

export fields_register, fields_all, fields_load_all

using ..Registry

const GLOBAL_FIELDS = Set{Symbol}()

"""
    fields_register(fields::Vector{Symbol})

Register these field names globally.
"""
function fields_register(fields::Vector{Symbol})
    union!(GLOBAL_FIELDS, fields)
end

fields_register([:category, :timestamp, :type])  # core fields

"""
    fields_all() -> Vector{Symbol}

Return all registered field names.
"""
fields_all() = sort(collect(GLOBAL_FIELDS))

"""
    fields_load_all()

Include every `*.jl` in `fields/` so that
they can call `fields_register(...)` and `set_many!(...)` directly.
"""
function fields_load_all()
    dir = normpath(joinpath(@__DIR__, "..", "fields"))
    for file in sort(readdir(dir))
        if endswith(file, ".jl")
            include(joinpath(dir, file))
        end
    end
end

fields_load_all()

end # module Loader