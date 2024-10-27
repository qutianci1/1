-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2023-08-26 01:59:55
-- @Last Modified time  : 2024-08-23 22:42:33

local NPC = {}
local 对话 = {
    [[真水无波，你们果真要为那奎宿与我开战?
menu
99|我不会游泳,还是算了
]],
    [[真水无波，你们果真要为那奎宿与我开战?
menu
1|你光棍哪懂爱的美！开战！
99|我不会游泳,还是算了
]]
}
function NPC:NPC对话(玩家, i)
    if os.date('%w', os.time()) == '2' then
        return 对话[2]
    end
    return 对话[1]
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        local r = 玩家:进入战斗('scripts/war/战斗_水德星君.lua')
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
    if 玩家:取活动限制次数('水德星君') >= 1 then
        玩家:常规提示('本日奖励次数已尽,无法继续获得奖励')
        return
    end
    玩家:增加活动限制次数('水德星君')
    local 银子 = 0
    local 经验 = 50000 * (玩家.等级 * 0.15)
    玩家:添加参战召唤兽经验(经验 * 1.5)
    玩家:添加银子(银子)
    玩家:添加经验(经验)
end

return NPC
