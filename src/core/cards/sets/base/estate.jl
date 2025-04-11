struct Estate <: Types.CardVictory
    cost::Int
    points::Int
end

set("Estate", () -> Estate(2, 1), () -> nothing)