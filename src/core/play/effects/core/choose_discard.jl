function choose_discard!(tpl, pl, game)
    minsel = Base.get(tpl.data, :min_discard, 0)
    maxsel = Base.get(tpl.data, :max_discard, :all)
    src     = Base.get(tpl.data, :discard_source, :hand)

    cards = getfield(pl, src)        # e.g. pl.hand
    nmax  = maxsel == :all ? length(cards) : Int(maxsel)

    return choose(:random, cards, minsel, nmax)
end

@register :choose_discard choose_discard!