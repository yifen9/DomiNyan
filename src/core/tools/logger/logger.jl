module Logger

export Log, init!, push!, state_export!, csv_export!, all_export!

using CSV
using DataFrames
using Dates
using JSON3
using OrderedCollections
using Threads
using UUIDs

using ..State
using ..Tracker

using ...Cards

# load field definitions
include("registry/fields_registry.jl")
using .Registry
include("loader/fields_loader.jl")
using .Loader

# -------------------------------------------------------------------
# Log : context for accumulating and flushing log entries
# -------------------------------------------------------------------
mutable struct Log
    folder::String                               # output directory for this session
    echo::Bool                                   # print each write?
    write_async::Bool                            # use Threads.@spawn for JSONL writes?
    jsonl::Bool                                  # write incremental .jsonl?
    csv_auto::Bool                               # auto‑flush CSV on each push?
    csv_cols_count::Int                          # last number of columns in CSV
    entries::Vector{OrderedDict{String,Any}}     # in‑memory full entries
    ReentrantLock::ReentrantLock                 # lock for thread safety

    function Log(folder, echo, write_async, jsonl, csv_auto)
        return new(folder, echo, write_async, jsonl, csv_auto, 0,
                   OrderedDict{String,Any}[],
                   ReentrantLock())
    end
end

# -------------------------------------------------------------------
# init!: create output folder and return Log
# -------------------------------------------------------------------
"""
    init!(; dir_base="../logs", echo=false,
          write_async=true, jsonl=true, csv_auto=false, tracker=nothing) -> Log

Create a new Logger session.

- `dir_base`    ⇒ root logs directory
- `echo`        ⇒ print path on each write
- `write_async` ⇒ spawn background task for JSONL writes
- `jsonl`       ⇒ append each entry to `log.jsonl`
- `csv_auto`    ⇒ auto‑flush `log.csv` after each push
- `tracker`     ⇒ optional Tracker.Track to forward entries to
"""
function init!(
    ; dir_base::AbstractString = "../logs",
      echo::Bool            = false,
      write_async::Bool     = true,
      jsonl::Bool           = true,
      csv_auto::Bool        = false,
      tracker::Union{Tracker.Track,Nothing} = nothing
)::Log
    ts     = Dates.format(now(), "yyyy-mm-dd_HH-MM-SS")
    folder = joinpath(dir_base, ts, "logger")
    try
        mkpath(folder)
    catch err
        @warn "Failed to create logger folder" folder err
    end

    log = Log(folder, echo, write_async, jsonl, csv_auto)
    log.tracker = tracker
    return log
end

# -------------------------------------------------------------------
# Helper: write one line to JSONL
# -------------------------------------------------------------------
function _jsonl_write(folder::String, entry)
    path = joinpath(folder, "log.jsonl")
    open(path, "a") do io
        JSON3.write(io, entry)
        write(io, '\n')
    end
end

# -------------------------------------------------------------------
# push!: record a single action
# -------------------------------------------------------------------
"""
    push!(log, action; data=Dict(), game=nothing)

Append one log entry:
 1. build a dictionary of common + action‑specific fields
 2. store in memory
 3. append to `log.jsonl` (possibly async)
 4. optionally flush CSV or forward to Tracker
"""
function push!(
    log::Log,
    action::Symbol;
    data::Dict{Symbol,Any}=Dict(),
    game::Union{State.Game,Nothing}=nothing
)
    # build base entry
    entry = OrderedDict{String,Any}()
    entry["id"]        = length(log.entries) + 1
    entry["timestamp"] = Dates.format(now(),
                             dateformat"yyyy-mm-ddTHH:MM:SS.sss")
    entry["category"]  = String(Registry.get_category(action))
    entry["type"]      = Registry.get_name(action)

    # fill action-specific fields
    for fld in Registry.get_fields(action)
        val = get(data, fld, missing)
        if fld in (:card_target, :card_source) && val !== missing
            try val = Cards.Registry.get_name(val) catch end
        end
        entry[String(fld)] = val
    end

    # fill game context if provided
    if game !== nothing
        entry["turn"]   = game.turn
        entry["player"] = game.current_player
        entry["phase"]  = string(game.phase)
    end

    # store in memory (thread‑safe)
    lock(log.ReentrantLock) do
        push!(log.entries, entry)
    end

    # append to JSONL
    if log.jsonl
        if log.write_async
            Threads.@spawn _jsonl_write(log.folder, entry)
        else
            _jsonl_write(log.folder, entry)
        end
    end

    # echo once
    log.echo && println("[LOGGER] ", entry["type"], " → ", entry["id"])

    # auto‑flush CSV only when column count grows
    if log.csv_auto && length(entry) > log.csv_cols_count
        csv_export!(log)
        log.csv_cols_count = length(entry)
    end

    # forward to Tracker if configured
    if hasproperty(log, :tracker) && log.tracker !== nothing && game !== nothing
        Tracker.push!(log.tracker, game; id=entry["id"])
    end

    return nothing
end

# -------------------------------------------------------------------
# state_export!: write full game snapshot
# -------------------------------------------------------------------
"""
    state_export!(game, path)

Write the complete game snapshot JSON to `path`.
"""
function state_export!(game::State.Game, path::AbstractString)
    try
        mkpath(dirname(path))
        open(path, "w") do io
            JSON3.write(io, State.game_snapshot(game); indent=2)
        end
    catch err
        @warn "Failed to write state JSON" path err
    end
    return nothing
end

# -------------------------------------------------------------------
# csv_export!: dump in‑memory entries to CSV
# -------------------------------------------------------------------
"""
    csv_export!(log)

Dump `log.entries` into `log.folder/log.csv`.
"""
function csv_export!(log::Log)
    # collect all keys present
    all_keys = union(collect(keys.(log.entries))...)
    cols     = sort(collect(all_keys))
    # build rows
    rows = [ get(e, c, missing) for e in log.entries, c in cols ]
    df   = DataFrame(rows, Symbol.(cols))
    path = joinpath(log.folder, "log.csv")
    CSV.write(path, df; writeheader=true)
    log.echo && println("[LOGGER] csv → ", path)
    return nothing
end

# -------------------------------------------------------------------
# all_export!: complete dump of CSV, state & Tracker
# -------------------------------------------------------------------
"""
    all_export!(log, game)

Perform full export of:
 1) log.csv  
 2) state.json  
 3) all Tracker artifacts
"""
function all_export!(log::Log, game::State.Game)
    csv_export!(log)
    state_export!(game, joinpath(log.folder, "state.json"))
    if hasproperty(log, :tracker) && log.tracker !== nothing
        Tracker.all_export!(log.tracker, game)
    end
    return nothing
end

end # module Logger