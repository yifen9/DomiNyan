struct Estate <: Types.CardVictory
    cost::Int
    vp::Int
end

set("Estate",
    () -> Estate(2, 1),
    () -> nothing
)