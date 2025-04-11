module Dispatcher

using ..Cards

export dispatcher

function dispatcher(card::Card, player::PlayerState)
    name = nameof(typeof(card))
    play_fn = card_play_get(string(name))
    return play_fn(card, player, nothing)
end

end