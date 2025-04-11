struct Estate <: CardVictory
    cost::Int
    points::Int
end

card_set("Estate", () -> Estate(2, 1), () -> nothing)