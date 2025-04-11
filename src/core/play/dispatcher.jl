module Dispatcher

using ..Card.types_Card

export dispatcher

function dispatcher(card::Card, player::PlayerState)
    name = nameof(typeof(card))
    play_fn = registry_get_play(string(name))
    return play_fn(card, player, nothing)
end

end