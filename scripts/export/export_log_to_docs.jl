module ExportLogToDocs

using ArgParse
using Dates
using FilePathsBase: basename
using JSON3
using OrderedCollections

const DOCS_DIR = joinpath("docs", "games")

function load_index(path::String)
    if isfile(path)
        return JSON3.read(read(path, String), Vector{OrderedDict{String, Any}})
    else
        return OrderedCollections.OrderedDict{String, Any}[]
    end
end

function save_index(index::Vector{OrderedDict{String, Any}}, path::String)
    sort!(index, by = x -> x["folder"], rev=true)
    open(path, "w") do io
        JSON3.write(io, index; indent=2)
    end
end

function find_latest_unexported_logdir(logs_root::String)::Union{String, Nothing}
    dirs = filter(
        entry -> isdir(joinpath(logs_root, entry)) &&
                 occursin(r"^\d{4}-\d{2}-\d{2}_\d{2}-\d{2}-\d{2}$", entry),
        readdir(logs_root)
    )
    sorted = sort(dirs; rev=true)
    for dir in sorted
        if !isdir(joinpath(DOCS_DIR, dir))
            return joinpath(logs_root, dir)
        end
    end
    return nothing
end

function export_log_to_docs(log_dir::String; copy_log_csv::Bool = true)
    log_dir = normpath(log_dir)
    timestamp = basename(log_dir)
    dest_dir = joinpath(DOCS_DIR, "data", timestamp)
    trackers_src = joinpath(log_dir, "tracker")
    trackers_dest = joinpath(dest_dir, "trackers")

    mkpath(trackers_dest)

    for file in filter(f -> endswith(f, ".json"), readdir(trackers_src; join=true))
        cp(file, joinpath(trackers_dest, basename(file)); force=true)
    end

    if isfile(joinpath(log_dir, "state.json"))
        cp(joinpath(log_dir, "state.json"), joinpath(dest_dir, "state.json"); force=true)
    end

    if copy_log_csv && isfile(joinpath(log_dir, "log.csv"))
        cp(joinpath(log_dir, "log.csv"), joinpath(dest_dir, "log.csv"); force=true)
    end

    index_path = joinpath(DOCS_DIR, "games_index.json")
    index = load_index(index_path)

    pushfirst!(index, OrderedDict(
        "folder" => timestamp,
        "count" => length(filter(f -> occursin(r"^\d+.*\.json$", f), readdir(trackers_dest))),
        "state" => isfile(joinpath(dest_dir, "state.json")),
        "csv" => copy_log_csv && isfile(joinpath(dest_dir, "log.csv")),
    ))

    save_index(index, index_path)
    println("[EXPORT] logs exported to -> ", dest_dir)
end

function main(args::Vector{String} = ARGS)
    copy_csv = !("--no-copy-log-csv" in args)

    if length(args) == 0
        logs_root = "logs"
        log_dir = find_latest_unexported_logdir(logs_root)
        if isnothing(log_dir)
            println("[INFO] No unexported logs found in logs/")
            return
        end
        println("[AUTO] Detected latest log -> $log_dir")
        return export_log_to_docs(log_dir; copy_log_csv=copy_csv)
    end

    path_arg = args[1]
    log_dir = if isdir(path_arg) && basename(path_arg) == "logs"
        find_latest_unexported_logdir(path_arg)
    else
        path_arg
    end

    if isnothing(log_dir)
        println("[INFO] No unexported logs found.")
        return
    end

    export_log_to_docs(log_dir; copy_log_csv=copy_csv)
end

function run()
    main(ARGS)
end

end # module

if abspath(PROGRAM_FILE) == @__FILE__
    ExportLogToDocs.run()
end