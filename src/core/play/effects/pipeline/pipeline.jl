module Pipeline

using ..Registry   # lookup atomic ops
export Step, Pipeline, run!

"""
    Step(op; args=Dict(), if_cond=nothing, loop_var=nothing)

One step in a pipeline:
- `op`        : Symbol of registered atomic effect
- `args`      : Dict{Symbol,Any} of keyword args
- `if_cond`   : Optional Function(results, tpl, pl, game)=>Bool
- `loop_var`  : Optional Symbol key to store the output
"""
struct Step
  op::Symbol
  args::Dict{Symbol,Any}
  if_cond::Union{Nothing,Function}
  loop_var::Union{Nothing,Symbol}
end

"""
    Pipeline(steps; returns=[])

A sequence of Steps.  After running, returns a NamedTuple of
the requested `returns` symbols.
"""
struct Pipeline
  steps::Vector{Step}
  returns::Vector{Symbol}
end

"""
    run!(pipe, tpl, player, game)

Execute each step in order.  Return NamedTuple(pipe.returns).
"""
function run!(pipe::Pipeline, tpl, player, game)
  results = Dict{Symbol,Any}()
  for st in pipe.steps
    if st.if_cond !== nothing && !st.if_cond(results, tpl, player, game)
      continue
    end
    # prepare call args, substitute prior results
    kw = Dict(st.args)
    for (k,v) in kw
      if v isa Symbol && haskey(results, v)
        kw[k] = results[v]
      end
    end
    # invoke atomic op
    fn = Play.Effects.Registry.get(st.op)
    out = fn(tpl, player, game; kw...)
    # save to loop_var if requested
    if st.loop_var !== nothing
      results[st.loop_var] = out
    end
  end
  # collect returns
  return NamedTuple{Tuple(pipe.returns)}(
    map(r->results[r], pipe.returns)...
  )
end

end # module