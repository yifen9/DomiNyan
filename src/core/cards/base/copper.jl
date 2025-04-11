using ..CardTypes
using ..CardRegistry: register_card

struct Copper <: CardTreasure
    cost::Int
    value::Int
end
Copper() = Copper(0, 1)

register_card("Copper", Copper)