module Logger

export init!, turn!, action!, export_csv, export_state, export_all

using CSV
using DataFrames
using Dates
using JSON3
using UUIDs

include("fields/fields.jl")
include("core/actions.jl")
include("core/phases.jl")

using .Fields
using .Actions
using .Phases

using ..State
using ...Play

mutable struct Log
    entries::Vector{Dict{String, Any}}
    folder::String
end

function dir_create()
    base = joinpath("..", "logs")
    if !isdir(base)
        mkdir(base)
    end
    timestamp = Dates.format(now(), "yyyy-mm-dd_HH-MM-SS")
    folder = joinpath(base, timestamp)
    mkdir(folder)
    return folder
end

function init!()
    folder = dir_create()
    return Log([], folder)
end

function turn!(log::Log, player::Int, turn::Int)
    push!(log.entries, Dict(
        Fields.get(:timestamp) => now(),
        Fields.get(:type) => Actions.name_get(:TurnStart),
        Fields.get(:player) => player,
        Fields.get(:turn) => turn,
    ))
end

function action!(
    log::Log, player_id::Int, action::Symbol;
    card::Union{String, Nothing} = nothing,
    phase::Union{Symbol, Nothing} = nothing,
    turn::Union{Int, Nothing} = nothing,
    extra::Dict{<:AbstractString, <:Any} = Dict{String, Any}()
)
    entry = Dict(
        Fields.get(:timestamp) => now(),
        Fields.get(:type) => Actions.name_get(action),
        Fields.get(:player) => player_id,
    )

    if turn !== nothing
        entry[Fields.get(:turn)] = turn
    end
    if card !== nothing
        entry[Fields.get(:card)] = card
    end
    if phase !== nothing
        entry[Fields.get(:phase)] = Phases.name_get(phase)
    end

    merge!(entry, extra)
    push!(log.entries, entry)
end

function export_csv(log::Log, filepath::String)
    entries_filled = map(log.entries) do entry
        entry_full = Dict{String, Any}()
        for key in Fields.all()
            entry_full[key] = haskey(entry, key) ? entry[key] : missing
        end
        entry_full
    end

    df = DataFrame(entries_filled)
    CSV.write(filepath, df)
end

function stringify_cardlist(cards::Vector{Types.Card})
    return [string(typeof(c).name.name) for c in cards]
end

function export_state(game::Game, path::String)
    players_data = [
        Dict(
            "id" => i,
            "hand" => stringify_cardlist(p.hand),
            "deck" => stringify_cardlist(p.deck),
            "discard" => stringify_cardlist(p.discard),
            "played" => stringify_cardlist(p.played),
            "actions" => p.actions,
            "coins" => p.coins,
            "buys" => p.buys
        ) for (i, p) in enumerate(game.players)
    ]

    supply_data = Dict(string(k) => v for (k, v) in game.supply)

    exportable = Dict(
        "game" => Dict(
            "turn" => game.player_current
        ),
        "players" => players_data,
        "supply" => supply_data
    )

    open(path, "w") do io
        JSON3.write(io, exportable; indent=2)
    end
end

function export_all(log::Log, game::Any, base_path::String="logs")
    timestamp = Dates.format(now(), "yyyy-mm-dd_HH-MM-SS")
    dir = joinpath("..", base_path, timestamp)
    mkpath(dir)

    export_csv(log, joinpath(dir, "log.csv"))
    export_state(game, joinpath(dir, "state.json"))
end

end