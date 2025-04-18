module Dispatcher

export dispatcher

using ..Types
using ..Player

function dispatcher(card::Types.Card, player::Player.State; args=nothing)
    name = nameof(typeof(card))
    play_fn = get_play(string(name))
    
    return play_fn(card, player, args)
end

end