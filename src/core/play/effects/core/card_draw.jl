using Random

function card_draw!(player::Player.State, n::Int)
    for _ in 1:n
        if isempty(player.deck)
            if isempty(player.discard)
                break
            else
                player.deck = shuffle!(copy(player.discard))
                empty!(player.discard)
            end
        end
        push!(player.hand, popfirst!(player.deck))
    end
    return Dict("card_draw" => n)
end

Registry.set!("card_draw", card_draw!)