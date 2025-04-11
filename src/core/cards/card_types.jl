export Card, CardTreasure, CardVictory, CardAction

abstract type Card end
abstract type CardTreasure <: Card end
abstract type CardVictory <: Card end
abstract type CardAction <: Card end