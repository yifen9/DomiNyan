module State

export Game, game_new, game_snapshot, game_json_save, game_json_load

using JSON3
using UUIDs

using ...Play
using ...Cards

mutable struct Game
    game_id::UUID
    turn::Int
    players::Vector{Play.Player.State}
    player_current::Int
    supply::Dict{String, Int}
    trash::Vector{Play.Types.Card}
end

function default_deck()
    copper = Cards.Registry.get_field("Copper")
    estate = Cards.Registry.get_field("Estate")

    return vcat(fill(copper, 7), fill(estate, 3))
end

function default_supply()
    return Dict(
        "Copper" => 60,
        "Silver" => 40,
        "Gold" => 30,
        "Estate" => 8,
        "Duchy" => 8,
        "Province" => 8,
        "Smithy" => 10,
        "Village" => 10,
        "Market" => 10,
        "Festival" => 10,
        "Laboratory" => 10,
        "Woodcutter" => 10
    )
end

function game_new(
    n_players::Int = 2;
    deck_fn::Function = default_deck,
    supply::Dict{String, Int} = default_supply(),
    random_start::Bool = true,
    player_start::Union{Int, Nothing} = nothing,
)
    game_id = UUIDs.uuid4()

    turn = 0

    players = [Play.Player.new(deck_fn()) for _ in 1:n_players]

    player_current = isnothing(player_start) ? (random_start ? rand(1:n_players) : 1) : player_start

    trash = Play.Types.Card[]

    return Game(
        game_id,
        turn,
        players,
        player_current,
        supply,
        trash,
)
end

function stringify_cardlist(cards::Vector{Types.Card})
    return sort([string(typeof(c).name.name) for c in cards])
end

function game_snapshot(game::Game)
    data_players = [
        Dict(
            "id" => i,
            "hand" => stringify_cardlist(p.hand),
            "deck" => stringify_cardlist(p.deck),
            "discard" => stringify_cardlist(p.discard),
            "played" => stringify_cardlist(p.played),
            "action" => p.action,
            "buy" => p.buy,
            "coin" => p.coin,
        ) for (i, p) in enumerate(game.players)
    ]

    data_supply = Dict(sort(collect(string(k) => v for (k, v) in game.supply)))

    data_trash = stringify_cardlist(game.trash)

    exportable = Dict(
        "game" => Dict(
            "game_id" => game.game_id,
            "turn" => game.turn,
            "supply" => data_supply,
            "trash" => data_trash,
        ),
        "players" => data_players,
        "play_current" => game.player_current,
    )

    return exportable
end

function game_json_save(game::Game, path::String)
    snapshot = game_snapshot(game)

    mkpath(dirname(path))

    open(path, "w") do io
        JSON3.write(io, snapshot; indent=2)
    end
end

function player_reconstruct(p)::Play.Player.State
    hand = [Cards.Registry.get_field(string(name)) for name in p["hand"]]
    deck = [Cards.Registry.get_field(string(name)) for name in p["deck"]]
    discard = [Cards.Registry.get_field(string(name)) for name in p["discard"]]
    played = [Cards.Registry.get_field(string(name)) for name in p["played"]]
    action = Int(p["action"])
    buy = Int(p["buy"])
    coin = Int(p["coin"])

    return Play.Player.State(
        hand = hand,
        deck = deck,
        discard = discard,
        played = played,
        action = action,
        buy = buy,
        coin = coin
    )
end

function game_json_load(path::String)::Game
    json = JSON3.read(read(path, String))

    game_id = UUID(json["game"]["game_id"])
    turn = json["game"]["turn"]

    players = [player_reconstruct(p) for p in json["players"]]
    player_current = json["play_current"]

    supply = Dict{String, Int}()
    for (k, v) in json["game"]["supply"]
        supply[string(k)] = Int(v)
    end

    trash = [Cards.Registry.get_field(string(name)) for name in json["game"]["trash"]]

    return Game(game_id, turn, players, player_current, supply, trash)
end

end