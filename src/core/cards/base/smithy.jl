struct Smithy <: CardAction
    cost::Int
end
Smithy() = Smithy(4)

function play(card::Smithy, player)
    cards_draw!(player, 3)
end

card_register("Smithy", Smithy)