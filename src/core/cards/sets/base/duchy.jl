struct Duchy <: Types.CardVictory
    cost::Int
    vp::Int
end

set("Duchy",
    () -> Duchy(5, 3),
    () -> nothing
)