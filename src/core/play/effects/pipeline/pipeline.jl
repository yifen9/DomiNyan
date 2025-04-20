module Pipeline

export Step, Flow, run!

using ..Registry

using ...Types
using ...Player


"""
    Step(op; args=nothing, condition=nothing, result_key=nothing)

One atomic step in a Flow:

- `op`         : Symbol of registered effect
- `args`       : Either a `Tuple`/`Vector` of positional args, or a `Dict{Symbol,Any}` of keyword args
- `condition`  : Optional `(results, card_source, pl, game)->Bool` to skip step
- `result_key` : Optional Symbol under which to store the step’s result
"""
struct Step
    op::Symbol
    args::Any
    condition::Union{Nothing,Function}
    result_key::Union{Nothing,Symbol}
    function Step(op; args=nothing, condition=nothing, result_key=nothing)
        new(op, args, condition, result_key)
    end
end

"""
    Flow(steps; returns=[])

A sequence of Steps.  `returns` lists which `result_key`s to extract at end.
"""
struct Flow
    steps::Vector{Step}
    returns::Vector{Symbol}
    Flow(steps::Vector{Step}; returns::Vector{Symbol}=Symbol[]) = new(steps, returns)
end

"""
    run!(flow, card_source, pl, game) -> NamedTuple

Executes each Step in order.  Returns a NamedTuple of `flow.returns`.
"""
function run!(
    flow::Flow,
    card_source::Types.CardTemplate,
    pl::Player.State,
    game
)
    @show flow
    @show card_source
    @show pl
    @show game

    results = Dict{Symbol,Any}()

    for st in flow.steps
        # 1) maybe skip
        if st.condition !== nothing && !st.condition(results, card_source, pl, game)
            continue
        end

        # 2) look up fn
        fn = Registry.get(st.op)

        # 3) dispatch with positional or keyword args
        out = if st.args === nothing
            fn(card_source, pl, game)
        elseif st.args isa Tuple || st.args isa AbstractVector
            fn(card_source, pl, game, st.args...)
        elseif st.args isa Dict
            fn(card_source, pl, game; st.args...)
        else
            error("Pipeline.Step.args must be Tuple, Vector, Dict or nothing")
        end

        # 4) store into results if requested
        if st.result_key !== nothing
            results[st.result_key] = out
        end
    end

    # 5) build the return NamedTuple
    if !isempty(flow.returns)
        vals = map(r->results[r], flow.returns)
        @show NamedTuple{Tuple(flow.returns)}(vals...)
        return NamedTuple{Tuple(flow.returns)}(vals...)
    else
        @show NamedTuple()
        return NamedTuple()
    end
end

end # module Pipeline