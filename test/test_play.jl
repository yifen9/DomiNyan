using Test
using DomiNyan

@testset "Play Logic" begin
    # 构造初始牌堆
    copper = Cards.Registry.get_field("Copper")
    deck = [copper for _ in 1:10]
    player = Play.Player.new(deck)

    Play.Effects.draw_cards!(player, 5)
    @test length(player.hand) == 5

    # 使用 Smithy 测试
    smithy = Cards.Registry.get_field("Smithy")
    play_fn = Cards.Registry.get_play("Smithy")

    hand_before = length(player.hand)
    play_fn(smithy, player)

    @test length(player.hand) == hand_before + 3
end