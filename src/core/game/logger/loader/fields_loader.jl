module Loader

const GLOBAL_FIELDS = Set{String}()

export fields_register, fields_all, fields_load_all

using ..Registry

function fields_register(fields::Vector{String})
    union!(GLOBAL_FIELDS, fields)
end

function fields_all()
    return sort(collect(GLOBAL_FIELDS))
end

function fields_load_all()
    fields_path = normpath(joinpath(@__DIR__, "..", "fields"))
    for file in sort(readdir(fields_path))
        if endswith(file, ".jl")
            include(joinpath(fields_path, file))
        end
    end
end

fields_register(["category", "timestamp", "type"])

fields_load_all()

end