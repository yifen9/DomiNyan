struct Estate <: CardVictory
    cost::Int
    points::Int
end

Estate() = Estate(2, 1)

card_register("Estate", Estate)