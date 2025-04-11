struct Copper <: CardTreasure
    cost::Int
    value::Int
end

Copper() = Copper(0, 1)

copper_play!(card, player) = nothing

card_set("Copper", Copper, copper_play!)