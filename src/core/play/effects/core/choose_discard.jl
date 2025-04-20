@register :choose_discard function tpl, pl, game;
    minsel = get(tpl.data, :min_discard, 0)
    maxsel = get(tpl.data, :max_discard, :all)
    src     = get(tpl.data, :discard_source, :hand)

    cards = getfield(pl, src)        # e.g. pl.hand
    nmax  = maxsel == :all ? length(cards) : Int(maxsel)

    return choose(:random, cards, minsel, nmax)
end