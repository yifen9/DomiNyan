module Registry

export REGISTRY, set!, get, exists, cards_list, @register

using ...Play                    # CardTemplate

const REGISTRY    = Dict{Symbol, Play.Types.CardTemplate}()
const NAME_LOOKUP = IdDict{Play.Types.CardTemplate, Symbol}()

"Register `tpl` under `key`."
function set!(key::Symbol, tpl::Play.Types.CardTemplate)
    REGISTRY[key] = tpl
    NAME_LOOKUP[tpl] = key
    return tpl
end

"Return template; throw if missing."
get(key::Symbol) = Base.get(REGISTRY, key) do
    error("Card $(key) not registered.")
end

"Whether a card symbol is already registered."
exists(key::Symbol) = haskey(REGISTRY, key)

"Return a sorted `Vector{Symbol}` listing all registered card names."
cards_list() = sort!(collect(keys(REGISTRY)))

# Convenience macro – no need for a separate file
"""
    @register sym expr

Create a CardTemplate via `expr` and register under `sym`.
"""
macro register(sym, expr)
    quote
        if exists($(esc(sym)))
            @warn "Card $(string($(esc(sym)))) is being overwritten."
        end
        set!($(esc(sym)), $(esc(expr)))
    end
end

end # module