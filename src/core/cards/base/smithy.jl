using ..CardTypes
using ..CardRegistry: card_register

struct Smithy <: CardAction
    cost::Int
end
Smithy() = Smithy(4)

card_register("Smithy", Smithy)