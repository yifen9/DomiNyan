using Test
using DomiNyan

@testset "Play Logic" begin
    # 构造初始牌堆
    copper = card_get_field("Copper")
    deck = [copper for _ in 1:10]
    player = player_new(deck)

    @test length(player.hand) == 5

    # 使用 Smithy 测试
    smithy = card_get_field("Smithy")
    play_fn = card_get_play("Smithy")

    hand_before = length(player.hand)
    play_fn(smithy, player)

    @test length(player.hand) == hand_before + 3
end