using Test
using DomiNyan

@testset "Types Tests" begin
    tpl  = DomiNyan.Play.Types.CardTemplate("X", 3, Set([:Action]), Dict(:foo=>10))
    info = DomiNyan.Play.Types.card_info(tpl)

    @test info.name == "X"
    @test info.cost == 3
    @test info.foo  == 10
    @test info.type == [:Action]
end

@testset "Player Tests" begin
    tpl  = DomiNyan.Play.Types.CardTemplate("D", 0, Set([:Treasure]), Dict())
    deck = [tpl for _ in 1:4]
    pl   = DomiNyan.Play.Player.new(deck; deck_shuffle=false)

    @test DomiNyan.Play.Player.deck_size(pl) == 4
    @test DomiNyan.Play.Player.hand_size(pl) == 0

    # dispatch with no effects leaves hand unchanged
    DomiNyan.Play.Effects.dispatch(tpl, pl, nothing)
    @test DomiNyan.Play.Player.hand_size(pl) == 0

    # call draw effect directly
    DomiNyan.Play.Effects.Loader.card_draw!(tpl, pl, nothing, 2)
    @test DomiNyan.Play.Player.hand_size(pl) == 2
end

@testset "Choose Tests" begin
    # Prepare sample data
    data = [10, 20, 30]

    # Override :random to always pick first element for predictability
    @DomiNyan.Play.Choose.Registry.register :random (args...) -> args[1][1]

    # Default choose(:random, ...)
    @test DomiNyan.Play.Choose.choose(:random, data) == 10

    # Register a simple “last element” strategy
    @DomiNyan.Play.Choose.Registry.register :last (args...) -> last(args[1])

    # Test named strategy
    @test DomiNyan.Play.Choose.choose(:last, data) == 30

    # Unknown name should fallback to :random
    @test DomiNyan.Play.Choose.choose(:unknown, data) == 10
end

@testset "Effects & Registry Tests" begin
    # define a dummy effect
    function plus_action!(_tpl, pl, _game, n=1)
        pl.action += n
        return (; gained=n)
    end

    # register it
    @DomiNyan.Play.Effects.register :plus_action plus_action!

    # build a template that uses the new effect
    tpl2 = DomiNyan.Play.Types.CardTemplate(
        "T", 0, Set([:Action]),
        Dict(:effects=>[:plus_action], :plus_action=>2)
    )
    pl2 = DomiNyan.Play.Player.new(DomiNyan.Play.Types.CardAbstract[]; deck_shuffle=false)

    # dispatch and check side‑effects + return value
    out = DomiNyan.Play.Effects.dispatch(tpl2, pl2, nothing)
    @test pl2.action == 3
    @test out[:gained] == 2

    # ensure registry.get returns our function
    f = DomiNyan.Play.Effects.Registry.get(:plus_action)
    @test f === plus_action!
end