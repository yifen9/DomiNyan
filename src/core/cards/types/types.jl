module Types

export types_Card, types_CardTreasure, types_CardVictory, types_CardAction

abstract type types_Card end
abstract type types_CardTreasure <: types_Card end
abstract type types_CardVictory <: types_Card end
abstract type types_CardAction <: types_Card end

end