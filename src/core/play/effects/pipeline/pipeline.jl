module Pipeline

export Step, Flow, pipeline!

using ..Registry

using ...Types
using ...Player

"""
    Step(op; args=nothing, condition=nothing, loop=nothing)

One atomic step in a Flow:

- `op`        : Symbol of registered effect
- `args`      : Tuple/Vector positional args, Dict keyword args, or Function for dynamic args
- `condition` : Optional (results, card, pl, game) → Bool to skip step
- `loop`      : Int for fixed repeats, or Function (results, card, pl, game, out, i) → Bool
"""
struct Step
    op::Symbol
    args::Any
    condition::Union{Nothing,Function}
    loop::Union{Nothing,Int,Function}
    function Step(op; args=nothing, condition=nothing, loop=nothing)
        new(op, args, condition, loop)
    end
end

"""
    Flow(steps)

A sequence of Steps.  Always returns a NamedTuple with a single field `pipeline`,
containing a Vector of each step’s result.
"""
struct Flow
    steps::Vector{Step}
end

"""
    pipeline!(flow, card_source, pl, game) -> NamedTuple

Executes each Step in order.  Always returns `(pipeline = Vector{Any})`.
"""
function pipeline!(
    card_source::Types.CardTemplate,
    pl::Player.State,
    game,
    flow::Flow
)::NamedTuple

    acc = Dict{Symbol, Any}()

    # helper to call one step
    call_step = function(st, prev, i)
        # compute args
        args_raw = st.args isa Function ?
            st.args(acc, card_source, pl, game, prev, i) :
            st.args
        fn = Registry.get(st.op)

        @show args_raw
        @show fn

        if args_raw === nothing
            fn(card_source, pl, game)
        elseif args_raw isa Tuple || args_raw isa AbstractVector
            fn(card_source, pl, game, args_raw...)
        elseif args_raw isa Dict
            fn(card_source, pl, game; args_raw...)
        else
            error("Invalid Step.args")
        end
    end

    for st in flow.steps
        # skip if condition fails
        if st.condition !== nothing && !st.condition(acc, card_source, pl, game)
            continue
        end

        # no loop? just once
        if st.loop === nothing
            out = call_step(st, nothing, 1)
            acc[st.op] = first(values(out))  # assume atomic returns NamedTuple with one field
            continue
        end

        # has loop: collect into a Vector
        # initialize
        val = call_step(st, nothing, 1)
        coll = Any[first(values(val))]     # first iteration
        # fixed-count loop
        if st.loop isa Int
        for i in 2:st.loop
            val = call_step(st, val, i)
            push!(coll, first(values(val)))
        end

        # function-guarded loop
        else
        i = 1
        while st.loop(acc, card_source, pl, game, val, i)
            i += 1
            val = call_step(st, val, i)
            push!(coll, first(values(val)))
        end
        end

        acc[st.op] = coll
    end

    @show acc

    keys = collect(keys(acc))
    vals = [acc[k] for k in keys]
    return NamedTuple{Tuple(keys)}(vals...)
end

@register :pipeline pipeline!

end # module Pipeline