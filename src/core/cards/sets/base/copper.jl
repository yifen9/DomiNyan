struct Copper <: CardTreasure
    cost::Int
    value::Int
end

set("Copper", () -> Copper(0, 1), () -> nothing)