module PlayLogic

using ..Types
using ..Player

export play

function play(card::Card, player::PlayerState)
    f = get(PLAY_DISPATCH, typeof(card), nothing)
    if f === nothing
        error("No play logic defined for card $(typeof(card))")
    end
    f(card, player)
end

end