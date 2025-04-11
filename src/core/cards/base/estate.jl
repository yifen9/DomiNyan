using ..CardTypes
using ..CardRegistry: register_card

struct Estate <: CardVictory
    cost::Int
    points::Int
end

Estate() = Estate(2, 1)

register_card("Estate", Estate)