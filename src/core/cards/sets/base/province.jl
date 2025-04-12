struct Province <: Types.CardVictory
    cost::Int
    vp::Int
end

set("Province",
    () -> Province(8, 6),
    (card, player, game) -> nothing
)