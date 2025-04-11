function draw_cards!(player::State, n::Int)
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
end

set!("draw_cards", draw_cards!)