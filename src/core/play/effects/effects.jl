module Effects

export Registry,                 # sub‑module
       Loader,
       Pipeline,
       dispatch                  # execute effects attached to a card

include("registry/registry.jl")  # defines module Registry
include("loader/core_loader.jl")
include("pipeline/pipeline.jl")

using .Registry
using .Loader
using .Pipeline

using ..Types
using ..Player

"""
    dispatch(
      card_source::Types.CardTemplate,
      pl::Player.State,
      game;
      overrides...
    ) -> Vector{NamedTuple}

For each effect symbol `sym` in `card_source.data[:effects]`, this function:

1. Looks up the implementation `fn = Registry.get(sym)`.  
2. Determines an extra value `val` by checking, in order:
     - `overrides[sym]` if provided,  
     - else `card_source.data[sym]` if present,  
     - else `nothing`.  
3. If `val === nothing`, calls `fn(card_source, pl, game)`.  
   Else if `val` is a tuple or vector, calls `fn(card_source, pl, game, val...)`.  
   Otherwise calls `fn(card_source, pl, game, val)`.  
4. Collects and returns all NamedTuple results in order.
"""
function dispatch(
    card_source::Types.CardTemplate,
    pl::Player.State,
    game;
    overrides...
)::Vector{NamedTuple}

    # collect results in order
    results = NamedTuple[]

    # effects
    for sym in Base.get(card_source.data, :effects, Symbol[])

        if sym === :pipeline # pipeline
            pipe = card_source.data[:pipeline]
            # assume pipe isa Pipeline.Flow or Pipeline.Node
            nt = Pipeline.run!(pipe, card_source, pl, game)

        else
            fn = Registry.get(sym)

            # pick override ▶ card data ▶ nothing
            val = haskey(overrides, sym) ? overrides[sym] :
                Base.get(card_source.data, sym, nothing)

            # invoke fn with 3 args or extra positional args
            nt = if val === nothing
                fn(card_source, pl, game)
            elseif isa(val, Tuple) || isa(val, AbstractVector)
                fn(card_source, pl, game, val...)
            else
                fn(card_source, pl, game, val)
            end
        end

        push!(results, nt)
    end

    return results
end

end # module Effects