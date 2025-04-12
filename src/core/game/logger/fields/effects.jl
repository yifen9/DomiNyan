import ..Loader: fields_register

fields_register(["card_target", "card_source", "card_count", "player"])

Registry.set_many!([
    (:CardDraw,  "CARD_DRAW",  :effect, [:card_target, :card_source, :card_count, :player]),
    (:CardPlay,  "CARD_PLAY",  :effect, [:card_target, :card_source, :card_count, :player]),
    (:CardBuy,   "CARD_BUY",   :effect, [:card_target, :card_source, :card_count, :player]),
    (:CardGain,  "CARD_GAIN",  :effect, [:card_target, :card_source, :card_count, :player]),
    (:CardTrash, "CARD_TRASH", :effect, [:card_target, :card_source, :card_count, :player]),
])