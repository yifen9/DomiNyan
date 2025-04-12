struct Province <: Types.CardVictory
    cost::Int
    vp::Int
end

Cards.Registry.set(
    "Province",
    () -> Province(8, 6),
    () -> nothing
)