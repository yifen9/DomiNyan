module RegistryLoader

function load_registries_all(registry_dir::String)
    for file in readdir(registry_dir)
        if endswith(file, ".jl")
            include(joinpath(registry_dir, file))
        end
    end
end

end