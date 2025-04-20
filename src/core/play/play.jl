"""
Play — high‑level façade for the Dominion engine.

`using Play` automatically loads and re‑exports the three internal
modules so that game scripts only need a single import:

* `Types`   – static card templates and type hierarchy
* `Player`  – per‑player runtime state (deck, hand, etc.)
* `Effects` – effect registry, dispatcher, and core effect loaders
"""
module Play

export Types, Choose, Player, Effects

include("types/types.jl")
include("player/player.jl")
include("choose/choose.jl")
include("effects/effects.jl")

using .Types
using .Player
using .Choose
using .Effects

end # module Play