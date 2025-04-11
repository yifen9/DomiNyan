struct Estate <: types_CardVictory
    cost::Int
    points::Int
end

registry_set("Estate", () -> Estate(2, 1), () -> nothing)