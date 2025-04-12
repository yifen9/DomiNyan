struct Duchy <: Types.CardVictory
    cost::Int
    vp::Int
end

Cards.Registry.set(
    "Duchy",
    () -> Duchy(5, 3),
    () -> nothing
)