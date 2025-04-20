import ..Loader: fields_register

fields_register([:card_target, :card_source, :card_count, :player])

Registry.set_many!([
    (:CardDraw,  "card_draw",  :effect, [:card_target, :card_source, :card_count, :player]),
    (:CardPlay,  "card_play",  :effect, [:card_target, :card_source, :card_count, :player]),
    (:CardBuy,   "card_buy",   :effect, [:card_target, :card_source, :card_count, :player]),
    (:CardGain,  "card_gain",  :effect, [:card_target, :card_source, :card_count, :player]),
    (:CardTrash, "card_trash", :effect, [:card_target, :card_source, :card_count, :player]),
])