module Choose

export strategy_set!, strategy_get

export CardAction
export CardBuy
export CardTrash
export CardGain

include("core/utils.jl")

using .Utils

include("core/card_action.jl")
include("core/card_buy.jl")
include("core/card_trash.jl")
include("core/card_gain.jl")

using .CardAction
using .CardBuy
using .CardTrash
using .CardGain

const STRATEGIES = Dict{Symbol, Function}()

function strategy_set!(key::Symbol, f::Function)
    STRATEGIES[key] = f
end

function strategy_get(key::Symbol)::Union{Function, Nothing}
    return get(STRATEGIES, key, nothing)
end

function __init__()
    strategy_set!(:card_action_default, CardAction.default)
    strategy_set!(:card_action_aggressive, CardAction.aggressive)
    strategy_set!(:card_action_conservative, CardAction.conservative)

    strategy_set!(:card_buy_default, CardBuy.default)
    strategy_set!(:card_buy_expensive, CardBuy.expensive_first)
    strategy_set!(:card_buy_victory, CardBuy.victory_only)

    strategy_set!(:card_trash_default, CardTrash.default)
    strategy_set!(:card_trash_low_cost, CardTrash.trash_low_cost)
    strategy_set!(:card_trash_victory, CardTrash.trash_victory_first)

    strategy_set!(:card_gain_default, CardGain.default)
    strategy_set!(:card_gain_expensive, CardGain.expensive_first)
    strategy_set!(:card_gain_victory, CardGain.victory_first)
    strategy_set!(:card_gain_treasure, CardGain.treasure_first)
end

end