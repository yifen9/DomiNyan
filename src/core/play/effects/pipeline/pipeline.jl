module Pipeline

export Step, Flow, run!

using ..Registry

using ...Types
using ...Player


"""
    Step(op; args=nothing, condition=nothing, result_key=nothing)

One atomic step in a Flow:

- `op`         : Symbol of registered effect
- `args`       :  
    • `Tuple`/`Vector` positional args  
    • `Dict{Symbol,Any}` keyword args  
    • `Function(results, card_source, pl, game, out, i) -> Union{Tuple,Vector,Dict}`  
      to dynamically compute args for each iteration  
- `condition`  : Optional `(results, card_source, pl, game)->Bool` to skip step
- `loop`       : 
    • `Int`: total iterations 
    • Function `(results, card_source, pl, game, out, i)->Bool` 
        to decide "whether to do once again"
- `result_key` : Optional Symbol under which to store the step’s result
"""
struct Step
    op::Symbol
    args::Any
    condition::Union{Nothing,Function}
    loop::Union{Nothing,Int,Function}
    result_key::Union{Nothing,Symbol}
    function Step(
        op;
        args       = nothing,
        condition  = nothing,
        loop       = nothing,
        result_key = nothing)
        new(op, args, condition, loop, result_key)
    end
end

"""
    Flow(steps; returns=[])

A sequence of Steps.  `returns` lists which `result_key`s to extract at end.
"""
struct Flow
    steps::Vector{Step}
    returns::Vector{Symbol}
    Flow(
        steps::Vector{Step};
        returns::Vector{Symbol} = Symbol[]
    ) = new(steps, returns)
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
    results = Dict{Symbol,Any}()

    # Helper: dispatch one invocation, using st.args which may be dynamic
    dispatch_with_args = function(st, out_prev, i)
        # Determine args for this iteration
        args_raw = if st.args isa Function
            st.args(results, card_source, pl, game, out_prev, i)
        else
            st.args
        end

        # Call the registered function with args_raw
        fn = Registry.get(st.op)
        if args_raw === nothing
            return fn(card_source, pl, game)
        elseif args_raw isa Tuple || args_raw isa AbstractVector
            return fn(card_source, pl, game, args_raw...)
        elseif args_raw isa Dict
            return fn(card_source, pl, game; args_raw...)
        else
            error("Pipeline.Step.args must be Tuple, Vector, Dict, Function or nothing")
        end
    end

    for st in flow.steps
        # 1) maybe skip
        if st.condition !== nothing && !st.condition(results, card_source, pl, game)
            continue
        end

        # 2) dispatch with positional or keyword args in a loop
        out = dispatch_with_args(st, nothing, 1)

        if st.loop isa Int
            for i in 2:st.loop
                out = dispatch_with_args(st, out, i)
            end

        elseif st.loop isa Function
            # takein (results, card_source, pl, game, out, iteration)
            i = 1
            while st.loop(results, card_source, pl, game, out, i)
                i += 1
                out = dispatch_with_args(st, out, i)
            end
        end

        # 4) store into results if requested
        if st.result_key !== nothing
            results[st.result_key] = out
            @show results
            @show results[st.result_key]
        end
    end

    # 5) build the return NamedTuple
    if !isempty(flow.returns)
        @show flow.returns
        vals = map(r->results[r], flow.returns)
        @show vals
        return NamedTuple{Tuple(flow.returns)}(vals...)
    else
        return NamedTuple()
    end
end

end # module Pipeline