module State

export Game,
       turn_next!, phase_next!, player_next!,
       game_new, game_snapshot, game_json_save, game_json_load

using JSON3
using OrderedCollections
using UUIDs

using ...Play
using ...Cards

# ------------------------------------------------------------
# Game : full runtime state of a Dominion game
# ------------------------------------------------------------
mutable struct Game
    id::UUID                             # unique game identifier
    turn::Int                            # turn counter
    phase::Symbol                        # current phase (:setup, :action, :buy, :cleanup, etc.)
    player_current::Int                  # index into players
    players::Vector{Play.Player.State}   # each player’s runtime state
    supply::Dict{String,Int}             # card piles remaining
    trash::Vector{Play.Types.CardAbstract}  # trashed cards
end

# ----------------------------------------------------------------------
# Turn management
# ----------------------------------------------------------------------
"""
    turn_next!(game)

Increment the game’s `turn` by 1.
"""
function turn_next!(game::Game)
    game.turn += 1
    return game
end

# ------------------------------------------------------------
# Phase management
# ------------------------------------------------------------
"""
    phase_next!(game)

Advance the game’s phase:
- :setup   → :action
- :action  → :buy
- :buy     → :cleanup
- :cleanup → :action
"""
function phase_next!(game::Game)
    # define the cycle mapping
    mapping = Dict(
        :setup   => :action,
        :action  => :buy,
        :buy     => :cleanup,
        :cleanup => :action
    )
    game.phase = get(mapping, game.phase, :setup)
    return game
end

"""
    player_next!(game)

Advance to the next player in turn order, wrapping back to 1.
"""
function player_next!(game::Game)
    n = length(game.players)
    game.player_current = (game.player_current % n) + 1
    return game
end

# ------------------------------------------------------------
# Default setup components
# ------------------------------------------------------------
"""
    deck_default() -> Vector{CardTemplate}

Return the standard starting deck: 7 Coppers + 3 Estates.
"""
deck_default() = let
    copper = Cards.Registry.get(:Copper)
    estate = Cards.Registry.get(:Estate)
    vcat(fill(copper,7), fill(estate,3))
end

"""
    supply_default() -> Dict{String,Int}

Return the standard supply counts for base cards.
"""
supply_default() = Dict(
    "Copper"    => 60,
    "Silver"    => 40,
    "Gold"      => 30,
    "Estate"    => 8,
    "Duchy"     => 8,
    "Province"  => 8,
    "Smithy"    => 10,
    "Village"   => 10,
    "Market"    => 10,
    "Festival"  => 10,
    "Laboratory"=> 10,
    "Woodcutter"=> 10
)

# ------------------------------------------------------------
# Constructor
# ------------------------------------------------------------
"""
    game_new(n_players; deck_fn=deck_default, supply=supply_default(),
             shuffle_start=true, deck_shuffle=true, start_player=nothing) -> Game

Create a fresh game with `n_players`.  

- `deck_fn`       ⇒ zero‑arg function returning the starting deck vector  
- `supply`        ⇒ Dict of card name → count for supply piles  
- `player_start_shuffle` ⇒ whether to randomly pick the first player  
- `deck_shuffle`  ⇒ whether to shuffle each player’s opening deck (default = `true`)  
- `player_start`  ⇒ if given, index of the first player (1–n_players)  
"""
function game_new(
    n_players::Int=2;
    player_start::Union{Nothing,Int}=nothing,
    player_start_shuffle::Bool=true,
    deck_fn::Function=deck_default,
    deck_shuffle::Bool=true,
    supply::Dict{String,Int}=supply_default()
)::Game
    # build each player's State, shuffling or not as requested
    players = [
        Play.Player.new(deck_fn(); deck_shuffle=deck_shuffle)
        for _ in 1:n_players
    ]

    current = isnothing(player_start)
        ? (player_start_shuffle ? rand(1:n_players) : 1)
        : player_start

    return Game(
        uuid4(),
        1,            # turn 1
        :setup,       # initial phase
        current,
        players,
        deepcopy(supply),
        Play.Types.CardAbstract[]
    )
end

# ------------------------------------------------------------
# Snapshot & serialization
# ------------------------------------------------------------
# helper: convert a Vector of cards to sorted name list
function _card_names(cards::Vector{Play.Types.CardAbstract})
    sort(string.(getfield.(cards, :name)))
end

"""
    game_snapshot(game) -> OrderedDict

Return an ordered, JSON‑friendly snapshot of the entire game state.
"""
function game_snapshot(game::Game)
    players_data = [
        OrderedDict(
            "id"       => i,
            "deck"     => _card_names(p.deck),
            "hand"     => _card_names(p.hand),
            "played"   => _card_names(p.played),
            "discard"  => _card_names(p.discard),
            "action"   => p.action,
            "buy"      => p.buy,
            "coin"     => p.coin,
        ) for (i, p) in enumerate(game.players)
    ]

    # sort supply by key
    supply_pairs = sort(collect(game.supply); by = x->lowercase(x.first))
    supply_data  = OrderedDict(supply_pairs)

    return OrderedDict(
        "game" => OrderedDict(
            "id"             => string(game.id),
            "turn"           => game.turn,
            "phase"          => string(game.phase),
            "player_current" => game.player_current,
            "supply"         => supply_data,
            "trash"          => _card_names(game.trash),
        ),
        "players" => players_data
    )
end

"""
    game_json_save(game, path)

Write `game_snapshot(game)` to `path` in JSON format.
"""
function game_json_save(game::Game, path::AbstractString)
    mkpath(dirname(path))
    open(path, "w") do io
        JSON3.write(io, game_snapshot(game); indent=2)
    end
    return path
end

"""
    game_json_load(path) -> Game

Read JSON from `path` and reconstruct the `Game` state.
"""
function game_json_load(path::AbstractString)::Game
    doc = JSON3.read(read(path, String))
    g = doc["game"]
    # rebuild players
    players = [ _player_rebuild(p) for p in doc["players"] ]
    # rebuild supply
    supply = Dict{String,Int}( string(k)=>Int(v) for (k,v) in g["supply"] )
    # rebuild trash
    trash  = [ Cards.Registry.get(Symbol(name)) for name in g["trash"] ]

    return Game(
        UUID(g["id"]),
        Int(g["turn"]),
        Symbol(g["phase"]),
        Int(g["player_current"]),
        players,
        supply,
        trash
    )
end

# ------------------------------------------------------------
# Internal helper: reconstruct a Player.State from snapshot
# ------------------------------------------------------------
function _player_rebuild(p)::Play.Player.State
    deck    = [ Cards.Registry.get(Symbol(name)) for name in p["deck"]    ]
    hand    = [ Cards.Registry.get(Symbol(name)) for name in p["hand"]    ]
    played  = [ Cards.Registry.get(Symbol(name)) for name in p["played"]  ]
    discard = [ Cards.Registry.get(Symbol(name)) for name in p["discard"] ]
    return Play.Player.State(
        deck, hand, played, discard,
        Int(p["action"]), Int(p["coin"]), Int(p["buy"])
    )
end

end # module State