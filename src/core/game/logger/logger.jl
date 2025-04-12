module Logger

export init!, turn!, action!, export_csv, export_state, export_all

using CSV
using DataFrames
using Dates
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

function export_all(log::Log, game::Any, base_path::String="logs")
    timestamp = Dates.format(now(), "yyyy-mm-dd_HH-MM-SS")
    dir = joinpath("..", base_path, timestamp)
    mkpath(dir)

    export_csv(log, joinpath(dir, "log.csv"))

    game_json_save(game, joinpath(dir, "state.json"))
end

end