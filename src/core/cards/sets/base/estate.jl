struct Estate <: CardVictory
    cost::Int
    points::Int
end

Estate() = Estate(2, 1)

estate_play!(card, player) = nothing

card_set("Estate", Estate, estate_play!)