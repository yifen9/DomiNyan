using ..CardTypes
using ..CardRegistry: card_register

struct Smithy <: CardAction
    cost::Int
end
Smithy() = Smithy(4)

function play(card::Smithy, player)
    draw_cards!(player, 3)
end

card_register("Smithy", Smithy)