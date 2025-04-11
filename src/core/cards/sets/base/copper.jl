struct Copper <: CardTreasure
    cost::Int
    value::Int
end

Copper() = Copper(0, 1)

card_register("Copper", Copper)