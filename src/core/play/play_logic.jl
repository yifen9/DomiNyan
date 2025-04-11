module PlayLogic

using ..Cards

export play_card

function play_card(card::Card, player::PlayerState)
    name = nameof(typeof(card))
    play_fn = card_get_play(string(name))
    return play_fn(card, player, nothing)
end

end