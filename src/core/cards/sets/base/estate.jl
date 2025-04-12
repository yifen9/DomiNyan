struct Estate <: Types.CardVictory
    cost::Int
    vp::Int
end

Cards.Registry.set(
    "Estate",
    () -> Estate(2, 1),
    () -> nothing
)