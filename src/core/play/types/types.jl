module Types

export CardAbstract,
       CardTreasure, CardVictory, CardAction,
       CardTemplate,
       Treasure, Victory, Action,
       card_info

# ----------------------------
# Core hierarchy (for dispatch)
# ----------------------------
abstract type CardAbstract end

abstract type CardTreasure <: CardAbstract end
abstract type CardVictory  <: CardAbstract end
abstract type CardAction   <: CardAbstract end

# ---------------------------------------------------------
# CardTemplate : immutable definition of a Dominion card
# ---------------------------------------------------------
"""
    CardTemplate(name, cost, type, data)

A generic, data‑oriented representation of a Dominion‑style card.

* `name`  – card name, e.g. "Copper"  
* `cost`  – printed cost in coins  
* `type`  – a `Set{Symbol}` such as `Set([:Treasure, :Reaction])`  
* `data`  – arbitrary `Dict{Symbol,Any}` for card‑specific fields  
"""
mutable struct CardTemplate <: CardAbstract
    name::String
    cost::Int
    type::Set{Symbol}
    data::Dict{Symbol,Any}
end

# keyword‐based outer constructor to match tests
"""
    CardTemplate(name; cost, type, data)

Keyword constructor forwarding to positional one, and ensuring
`data` is converted to `Dict{Symbol,Any}`.
"""
function CardTemplate(
    name::String;
    cost::Int,
    type::Set{Symbol},
    data::AbstractDict
)
    # convert any key‐type dict into Dict{Symbol,Any}
    data_sym = Dict{Symbol,Any}()
    for (k,v) in data
        # only allow Symbol keys
        k_sym = k isa Symbol ? k : error("CardTemplate data keys must be Symbol, got $(typeof(k))")
        data_sym[k_sym] = v
    end
    CardTemplate(name, cost, type, data_sym)
end

# ----------------------------
# Convenience constructors
# ----------------------------
"""
    Treasure(name; cost, player_coin_gain)

Create a standard Treasure card.
"""
Treasure(
    name::String;
    cost::Int,
    player_coin_gain::Int
) = CardTemplate(
    name,
    cost,
    Set([:Treasure]),
    Dict(:player_coin_gain => player_coin_gain)
)

"""
    Victory(name; cost, vp)

Create a standard Victory card.
"""
Victory(
    name::String;
    cost::Int,
    vp::Int
) = CardTemplate(
    name,
    cost,
    Set([:Victory]), Dict(:vp => vp)
)

"""
    Action(name; cost, kwargs...)

Create an Action card. Extra keyword arguments are stored in the
`data` dictionary, so you can write e.g.

```julia
smithy = Action("Smithy"; cost = 4, draw = 3)
```
"""
Action(
    name::String;
    cost::Int,
    kwargs...
) = CardTemplate(
    name,
    cost,
    Set([:Action]),
    Dict(kwargs)
)

"""
    card_info(card; data_merge = true) -> NamedTuple

Return a NamedTuple summarising all public fields.  
If `data_merge` is true, the `data` dictionary is splatted into the tuple,
so `card_info(copper)[:player_coin_gain] == 1`.
"""
function card_info(card::CardTemplate; data_merge::Bool = true)
    base = (name = card.name,
            cost = card.cost,
            type = collect(card.type))
    if data_merge
        return merge(base, NamedTuple(card.data))
    else
        return merge(base, (data = deepcopy(card.data),))
    end
end

end # module