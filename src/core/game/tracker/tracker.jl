module Tracker

export init!, push!, export_state_final, export_tracker_index, export_all

using Dates
using JSON3
using OrderedCollections

using ..State

mutable struct Log
    folder::String
    count::Int  # 用于自动编号 tracker 文件
    echo::Bool
end

"""
    dir_create(base::String = joinpath("..", "logs"))

生成 tracker 存储目录路径。
"""
function dir_create(base::String = joinpath("..", "logs"))
    timestamp = Dates.format(now(), "yyyy-mm-dd_HH-MM-SS")
    folder = joinpath(base, timestamp, "tracker")
    mkpath(folder)
    return folder
end

"""
    init!(; echo::Bool = false)

初始化 tracker 日志结构。
"""
function init!(; echo::Bool = false)
    folder = dir_create()
    return Log(folder, 0, echo)
end

"""
    push!(tracker::Log, game::State.Game, log_id::Union{Int, Nothing}=nothing)

记录当前玩家的完整状态为单独的 JSON 文件。
- 文件名格式为：
  [log_id]_[turn]_[player]_[phase].json
  eg. 00001322_0081_01_cleanup.json
"""
function push!(tracker::Log, game::State.Game, log_id::Union{Int, Nothing}=nothing)
    tracker.count += 1
    id = isnothing(log_id) ? tracker.count : log_id

    filename = "$(lpad(string(id), 8, '0'))_" *
               "$(lpad(string(game.turn), 4, '0'))_" *
               "$(lpad(string(game.player_current), 2, '0'))_" *
               "$(game.phase).json"
    filepath = joinpath(tracker.folder, filename)

    State.game_json_save(game, filepath)

    if tracker.echo
        println("[TRACKER] -> ", filepath)
    end
end

function export_state_final(game::State.Game, path::String)
    snapshot = State.game_snapshot(game)
    open(path, "w") do io
        JSON3.write(io, snapshot; indent=2)
    end
end

"""
    export_index(tracker::Log)

导出索引文件 tracker_index.json 至 tracker 文件夹下。
"""
function export_tracker_index(tracker::Log)
    entries = Vector{OrderedDict{String, Any}}()

    for file in filter(f -> endswith(f, ".json"), readdir(tracker.folder; join=true))
        fname = basename(file)
        parts = split(splitext(fname)[1], '_')

        if length(parts) == 4
            log_id = parse(Int, parts[1])
            turn = parse(Int, parts[2])
            player = parse(Int, parts[3])
            phase = parts[4]

            Base.push!(entries, OrderedDict(
                "log_id" => log_id,
                "path" => file,
                "filename" => fname,
                "turn" => turn,
                "player" => player,
                "phase" => phase,
            ))
        end
    end

    sort!(entries, by = x -> x["log_id"])

    path_index = joinpath(tracker.folder, "..", "tracker_index.json")
    open(path_index, "w") do io
        JSON3.write(io, entries; indent=2)
    end

    if tracker.echo
        println("[TRACKER] index -> ", path_index)
    end
end

"""
    export_all(tracker::Log)

保留用于后续扩展，如额外导出汇总索引等。
"""
function export_all(tracker::Log, game::State.Game)
    export_state_final(game, joinpath(tracker.folder, "..", "state.json"))
    export_tracker_index(tracker)
    return nothing
end

end