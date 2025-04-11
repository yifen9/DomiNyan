struct Copper <: CardTreasure
    cost::Int
    value::Int
end

card_set("Copper", () -> Copper(0, 1), () -> nothing)