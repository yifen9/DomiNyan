module Dispatcher

using ..Cards.Types
using ..Player

export dispatcher

function dispatcher(card::Card, player::State; args=nothing)
    name = nameof(typeof(card))
    play_fn = get_play(string(name))
    
    return play_fn(card, player, args)
end

end