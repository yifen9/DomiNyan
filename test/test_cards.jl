using Test
using DomiNyan

@testset "Registry API" begin
    # Use the Treasure constructor to build a template
    tpl = DomiNyan.Play.Types.Treasure("Dummy"; cost = 0, player_coin_gain = 5)
    DomiNyan.Cards.Registry.set!(:dummy, tpl)

    @test DomiNyan.Cards.Registry.exists(:dummy)
    @test DomiNyan.Cards.Registry.get(:dummy) === tpl
    @test :dummy in DomiNyan.Cards.Registry.cards_list()
end

@testset "@register Macro" begin
    # Register via macro using the same Treasure constructor
    @DomiNyan.Cards.register :macro_test DomiNyan.Play.Types.Treasure("M"; cost = 1, player_coin_gain = 2)
    mt = DomiNyan.Cards.Registry.get(:macro_test)

    @test mt.name == "M"
    @test mt.cost == 1
    @test mt.data[:player_coin_gain] == 2
end

@testset "Loader Behavior" begin
    # Ensure "base" is among the available sets
    sets = DomiNyan.Cards.Loader.set_list()
    @test "base" in sets

    # Unregister everything except Copper to isolate our test
    for sym in DomiNyan.Cards.Registry.cards_list()
        if sym != :Copper
            delete!(DomiNyan.Cards.Registry.REGISTRY, sym)
        end
    end

    # Load only Copper from the base set
    DomiNyan.Cards.Loader.sets_load!(sets = ["base"], cards = [:Copper])
    @test DomiNyan.Cards.Registry.exists(:Copper)
end

@testset "Cellar Effect Pipeline" begin
    # Prepare a dummy card template X and a Player.State
    dummy = DomiNyan.Play.Types.CardTemplate(
        "X"; 
        cost = 0, 
        type = Set([:Treasure]), 
        data = Dict()
    )
    # Build a player with known hand/deck (no shuffle)
    pl = DomiNyan.Play.Player.new([dummy for _ in 1:6]; deck_shuffle=false)
    # Force exactly 3 cards in hand and 3 in deck
    pl.hand    = [dummy, dummy, dummy]
    pl.deck    = [dummy, dummy, dummy]
    pl.discard = DomiNyan.Play.Types.CardAbstract[]

    # Override choose_discard to always pick the first two cards
    # @DomiNyan.Play.Effects.Registry.register :choose_discard (_card_source, pl, _game, args...) -> pl.hand[1:2]

    @show DomiNyan.Play.Effects.Registry.get(:choose_discard)

    # Fetch our Cellar template and dispatch its effects
    DomiNyan.Cards.Loader.sets_load!(sets = ["base"], cards = [:Cellar])
    tpl_cellar = DomiNyan.Cards.Registry.get(:Cellar)
    @show Play.Player.deck_size(pl)
    @show Play.Player.hand_size(pl)
    @test pl.action == 1
    results = DomiNyan.Play.Effects.dispatch(tpl_cellar, pl, nothing)

    # 1) +1 action should have been applied
    @test pl.action == 2

    @show Play.Player.deck_size(pl)
    @show Play.Player.hand_size(pl)
    @show results
    @show results[1]
    @show results[2]
    @show results[2][:chosen]

    # 2) Pipeline returns exactly the two discarded cards
    @test length(results) == 2
    @test length(results[1][:chosen]) == 2

    # 3) Hand size: 3 initial – 2 discarded + 2 drawn = 3
    @test length(pl.hand) == 3

    # 4) Deck size: 3 initial – 2 drawn = 1
    @test length(pl.deck) == 1
end