module CardTrash

export default, trash_low_cost, trash_victory_first

using ..Utils

using ....Play
using ....Cards

"""
默认策略：不弃任何牌
"""
function default(player::Play.Player.State, game; max_count::Int = 1)
    return String[]
end

"""
策略：优先弃掉花费最低的牌（如铜币、诅咒）
"""
function trash_low_cost(player::Play.Player.State, game; max_count::Int = 1)
    hand_names = map(Cards.Registry.get_name, player.hand)
    sorted = Utils.card_sort_by_cost(hand_names)
    return first(sorted, min(length(sorted), max_count))
end

"""
策略：优先弃掉胜利卡（如庄园），尤其是前期
"""
function trash_victory_first(player::Play.Player.State, game; max_count::Int = 1)
    hand_names = map(Cards.Registry.get_name, player.hand)
    results = String[]
    for name in hand_names
        card = Cards.Registry.get_field(name)
        if card isa Cards.CardVictory
            push!(results, name)
            if length(results) ≥ max_count
                break
            end
        end
    end
    return results
end

end