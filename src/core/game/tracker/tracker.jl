module Tracker

export init!, push!, export_all

using Dates
using JSON3

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

"""
    export_all(tracker::Log)

保留用于后续扩展，如额外导出汇总索引等。
"""
function export_all(tracker::Log)
    # 当前实现不做其他导出，保留接口
    return nothing
end

end