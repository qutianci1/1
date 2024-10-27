-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2023-08-26 01:59:55
-- @Last Modified time  : 2024-08-23 22:42:49

local NPC = {}
local 对话 = {
    [[说起胡敬德你可能不熟,但你可曾听过尉迟恭#28哈哈哈哈!
menu
99|准备一下先
]],
    [[说起胡敬德你可能不熟,但你可曾听过尉迟恭#28哈哈哈哈!
menu
1|久仰久仰
99|准备一下先
]]
}
function NPC:NPC对话(玩家, i)
    if os.date('%w', os.time()) == '5' then
        return 对话[2]
    end
    return 对话[1]
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        local r = 玩家:进入战斗('scripts/war/战斗_胡敬德.lua')
        if r then
            if 玩家.是否组队 then
                for _, v in 玩家:遍历队伍() do
                    self:掉落包(v)
                end
            else
                self:掉落包(玩家)
            end
        end
    end
end

local _掉落 = {
    {几率 = 10, 名称 = '悔梦石', 数量 = 1, 广播 = '#C水水谁%s获得了什么#G#m(%s)[%s]#m#n'},
    {几率 = 10, 名称 = '亲密丹', 数量 = 1, 参数 = 1000}
}
function NPC:掉落包(玩家)
    if 玩家:取活动限制次数('胡敬德') > 1 then
        玩家:常规提示('本日奖励次数已尽,无法继续获得奖励')
        return
    end
    玩家:增加活动限制次数('胡敬德')
    local 银子 = 0
    local 经验 = 50000 * (玩家.等级 * 0.15)
    玩家:添加参战召唤兽经验(经验 * 1.5)
    玩家:添加银子(银子)
    玩家:添加经验(经验)
end

return NPC
