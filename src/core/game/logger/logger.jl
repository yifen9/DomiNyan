module Logger

const CSV_COLUMNS = [
    "log_id",
    "game_id",
    "timestamp",
    "category",
    "type",
    "turn",
    "player",
    "phase",
    "card_target",
    "card_source",
    "card_count",
]

export init!, push!, export_csv, export_state, export_all

using CSV
using DataFrames
using Dates
using JSON3
using UUIDs

include("registry/fields_registry.jl")

using .Registry

include("loader/fields_loader.jl")

using .Loader

@eval fields_load_all()
@eval fields_all()

using ..State
using ..Tracker

using ...Play

mutable struct Log
    entries::Vector{Dict{String, Any}}
    folder::String
    echo::Bool
    game::Union{State.Game, Nothing}
    tracker::Union{Tracker.Log, Nothing}
end

function dir_create(base::String = joinpath("..", "logs"))
    timestamp = Dates.format(now(), "yyyy-mm-dd_HH-MM-SS")
    folder = joinpath(base, timestamp)
    mkpath(folder)
    return folder
end

function init!(;
    echo::Bool = false,
    game::Union{State.Game, Nothing} = nothing,
    tracker::Union{Tracker.Log, Nothing} = Tracker.init!()
)::Log
    folder = dir_create()
    return Log([], folder, echo, game, tracker)
end

function push!(log::Log, action::Symbol; data=Dict{Symbol, Any}(), game::Union{State.Game, Nothing}=nothing)
    log_id = length(log.entries) + 1

    entry = Dict{String, Any}(
        "log_id" => log_id,
        "timestamp" => now(),
        "category" => String(Registry.get_category(action)),
        "type" => Registry.get_name(action),
    )

    for field in Registry.get_fields(action)
        val = get(data, field, missing)

        if field in (:card_target, :card_source)
            if val !== missing
                try
                    val = Cards.Registry.get_name(val)
                catch
                end
            end
        end

        entry[string(field)] = val
    end

    Base.push!(log.entries, entry)

    if log.echo
        println("[LOG] -> ", Registry.get_name(action), " ", entry)
    end

    game_used = isnothing(game) ? log.game : game

    if log.tracker !== nothing && game_used !== nothing
        Tracker.push!(log.tracker, game_used, log_id)
    end
end

function fill_missing_fields!(log::Logger.Log)
    current_turn = missing
    current_player = missing
    current_phase = missing

    for entry in log.entries
        typ = get(entry, "type", "")
        sym = Registry.get_by_name(typ)
        category = sym === nothing ? :unknown : Registry.get_category(sym)

        # --------------- turn ---------------
        if haskey(entry, "turn")
            current_turn = entry["turn"]
        elseif current_turn !== missing && !(category in (:game,))
            entry["turn"] = current_turn
        end

        # --------------- player ---------------
        if haskey(entry, "player")
            current_player = entry["player"]
        elseif current_player !== missing && !(category in (:game,))
            entry["player"] = current_player
        end

        # --------------- phase ---------------
        if haskey(entry, "phase")
            if !(category in (:game, :turn))
                current_phase = entry["phase"]
            end
        elseif current_phase !== missing && !(category in (:game, :turn))
            entry["phase"] = current_phase
        end
    end
end

function export_csv(log::Log)
    fill_missing_fields!(log)  # auto fill turn, phase, player

    # collect all the keys（flatten keys from all entries）
    entry_keys = collect(Iterators.flatten(keys.(log.entries)))
    all_keys = union(CSV_COLUMNS, entry_keys)
    columns = vcat(CSV_COLUMNS, setdiff(all_keys, CSV_COLUMNS))  # save order

    # prepare for DataFrame
    entries_filled = map(log.entries) do entry
        filled = Dict{String, Any}()

        for key in columns
            filled[key] = Base.get(entry, key, missing)
        end

        return filled
    end

    df = select(DataFrame(entries_filled), Symbol.(columns))
    CSV.write(joinpath(log.folder, "log.csv"), df; header=true)
end

function export_state(game::State.Game, path::String)
    snapshot = State.game_snapshot(game)
    open(path, "w") do io
        JSON3.write(io, snapshot; indent=2)
    end
end

function export_all(log::Log, game::State.Game)
    export_csv(log)
    export_state(game, joinpath(log.folder, "state.json"))
end

end