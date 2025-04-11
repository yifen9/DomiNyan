struct Copper <: types_CardTreasure
    cost::Int
    value::Int
end

registry_set("Copper", () -> Copper(0, 1), () -> nothing)