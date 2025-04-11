module RegistryPlay

export PLAY_DISPATCH, play_register

const PLAY_DISPATCH = Dict{DataType, Function}()

function play_register!(T::DataType, f::Function)
    PLAY_DISPATCH[T] = f
end

end