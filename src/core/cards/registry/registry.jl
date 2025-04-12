module Registry

export REGISTRY, set, get, get_field, get_play, get_name

# --------------------------------------------------
# 类型定义
# --------------------------------------------------

struct Entry
    constructor::Function
    play_function::Function
end

# --------------------------------------------------
# 全局字典
# --------------------------------------------------

const REGISTRY = Dict{String, Entry}()
const NAME_LOOKUP = IdDict{Any, String}()  # 将卡牌实例映射到名称

# --------------------------------------------------
# 注册新卡牌
# --------------------------------------------------

"""
    set(name::String, constructor::Function, play_function::Function)

注册一张卡牌，包括构造函数与对应的 play 函数。
"""
function set(name::String, constructor::Function, play_function::Function)
    REGISTRY[name] = Entry(constructor, (card, player, game=nothing) -> play_function(card, player))
    NAME_LOOKUP[constructor()] = name
end

# --------------------------------------------------
# 基础检查与报错
# --------------------------------------------------

exists(name::String) = haskey(REGISTRY, name)

function not_found(name::String)
    error("Card '$name' not found. Available cards: $(join(keys(REGISTRY), ", "))")
end

# --------------------------------------------------
# 获取构造器与 play 函数
# --------------------------------------------------

"""
    get(name) -> (card, play_function)

返回对应卡牌的实例和其 play 函数。
"""
function get(name::String)
    exists(name) || not_found(name)
    entry = REGISTRY[name]
    return entry.constructor(), entry.play_function
end

"""
    get_field(name) -> card

仅返回卡牌实例（不带 play 函数）。
"""
function get_field(name::String)
    exists(name) || not_found(name)
    return REGISTRY[name].constructor()
end

"""
    get_play(name) -> (card, player, game) -> ...

返回标准 play 函数（总是三参格式，兼容默认参数）
"""
function get_play(name::String)
    exists(name) || not_found(name)
    f = REGISTRY[name].play_function
    return (card, player, game=nothing) -> f(card, player, game)
end

"""
    get_play(card) -> f(card, player, game)

从卡牌实例获取注册的 play 函数。
"""
function get_play(card::Any)
    name = get_name(card)
    f = REGISTRY[name].play_function
    return (card, player, game=nothing) -> f(card, player, game)
end

# --------------------------------------------------
# 获取卡牌名称
# --------------------------------------------------

"""
    get_name(card) -> name

从卡牌实例获取其注册名。
"""
function get_name(card::Any)
    return something(Base.get(NAME_LOOKUP, card, nothing), _slow_name_lookup(card))
end

function _slow_name_lookup(card::Any)
    for (k, v) in REGISTRY
        if v.constructor() == card
            NAME_LOOKUP[card] = k  # 缓存以加快下次调用
            return k
        end
    end
    error("Card name not found for given card: $card")
end

end