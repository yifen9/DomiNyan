module Tracker

export Track, init!, push!, state_export!, index_export!, all_export!

using Dates
using JSON3
using OrderedCollections

using ..State

# ------------------------------------------------------------
# Track : context for writing snapshot files & index
# ------------------------------------------------------------
mutable struct Track
    folder::String                                # root folder for this session
    id_next::Int                                  # auto‑incrementing record id
    echo::Bool                                    # whether to print on each write
    snapshot_async::Bool
    index_auto::Bool                              # write index after each push?
    index_jsonl::Bool
    entries::Vector{OrderedDict{String,Any}}      # in‑memory index entries
    # inner constructor
    Track(folder, echo, index_auto) = new(
        folder, 1, echo, index_auto, OrderedDict{String,Any}[]
    )
end

# ------------------------------------------------------------
# Initialize tracker: create timestamped directory
# ------------------------------------------------------------
"""
    init!(; base_dir="../logs", echo=false, index_auto=true) -> Track

Create a new tracker session.

- `base_dir`    ⇒ root directory under which a
                  timestamped `tracker/` folder is created.
- `echo`        ⇒ whether to print each file path.
- `index_auto`  ⇒ whether to flush index.json after each push.
"""
function init!(
    ; base_dir::AbstractString = "../logs",
      echo::Bool           = false,
      snapshot_async::Bool = true,
      index_auto::Bool     = true,
      jsonl_index::Bool    = true
)::Track
    ts     = Dates.format(now(), "yyyy-mm-dd_HH-MM-SS")
    folder = joinpath(base_dir, ts, "tracker")
    try
        mkpath(folder)
    catch err
        @warn "Failed to create tracker folder" folder err
    end
    return Track(folder, echo, snapshot_async, index_auto, jsonl_index)
end

# ------------------------------------------------------------
# Push one snapshot and record in‑memory index
# ------------------------------------------------------------
"""
    push!(track, game; id=nothing)

Write a JSON snapshot of `game` and append an index entry.
"""
function push!(
    track::Track,
    game::State.Game;
    id::Union{Nothing,Int}=nothing
)
    # determine record id
    id_rec = isnothing(id) ? track.id_next : id
    track.id_next = id_rec + 1

    # build filename: ID_TURN_PLAYER_PHASE.json
    fname = lpad(string(id_rec),8,'0') * "_" *
            lpad(string(game.turn),4,'0') * "_" *
            lpad(string(game.player_current),2,'0') * "_" *
            string(game.phase) * ".json"
    path = joinpath(track.folder, fname)

    # write snapshot, warn on failure
    if track.snapshot_async
        Threads.@spawn try
            State.game_json_save(game, path)
        catch err
            @warn "Async snapshot failed" path err
        end
    else
        try
            State.game_json_save(game, path)
        catch err
            @warn "Snapshot failed" path err
        end
    end

    # record entry with timestamp
    entry = OrderedDict{String,Any}(
        "id"        => id_rec,
        "turn"      => game.turn,
        "player"    => game.player_current,
        "phase"     => string(game.phase),
        "timestamp" => Dates.format(now(), "yyyy-mm-ddTHH:MM:SS"),
        "file"      => fname
    )
    push!(track.entries, entry)

    # realtime index flush?
    if track.index_auto
        if track.jsonl_index
            # append one JSON line
            idx_path = joinpath(track.folder, "..", "tracker_index.jsonl")
            open(idx_path, "a") do io
                JSON3.write(io, entry)
                write(io, "\n")
            end
        else
            index_export!(track)
        end
    end

    # optional echo
    track.echo && println("[TRACKER] snapshot -> ", path)
    return nothing
end

# ------------------------------------------------------------
# Export the final full game state
# ------------------------------------------------------------
"""
    state_export!(game, path)

Write the complete game snapshot to `path`.
"""
function state_export!(game::State.Game, path::AbstractString)
    dir = dirname(path)
    try
        mkpath(dir)
        open(path, "w") do io
            JSON3.write(io, State.game_snapshot(game); indent=2)
        end
    catch err
        @warn "Failed to write final state" path err
    end
    return nothing
end

# ------------------------------------------------------------
# Write the in‑memory index to disk
# ------------------------------------------------------------
"""
    index_export!(track)

Write `track.entries` into `tracker_index.json` (one level up).
"""
function index_export!(track::Track)
    path = joinpath(track.folder, "..", "tracker_index.json")
    try
        open(path, "w") do io
            JSON3.write(io, track.entries; indent=2)
        end
        track.echo && println("[TRACKER] index -> ", path)
    catch err
        @warn "Failed to write tracker index" path err
    end
    return nothing
end

# ------------------------------------------------------------
# Export everything: final state + index
# ------------------------------------------------------------
"""
    all_export!(track, game)

Write final state and index.  Call once at end of session.
"""
function all_export!(track::Track, game::State.Game)
    # final state one level up
    state_export!(game, joinpath(track.folder, "..", "state.json"))
    index_export!(track)
    return nothing
end

end # module Tracker