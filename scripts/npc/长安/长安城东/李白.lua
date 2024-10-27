-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2024-08-14 10:18:33
-- @Last Modified time  : 2024-08-23 22:43:22
local NPC = {}
local 对话 = {
    [[我天天喝酒，喝死拉倒#28
menu
99|离开
]],
    [[我天天喝酒，喝死拉倒#28
menu
1|灌他
99|离开
]]
}
function NPC:NPC对话(玩家, i)
    if os.date('%w', os.time()) == '2' then --
        return 对话[2]
    end
    return 对话[1]
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        if 玩家:删除物品('西风烈', 1) then
            local r = 玩家:进入战斗('scripts/war/李白.lua')
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
end

local _掉落 = {
    {几率 = 10, 名称 = '悔梦石', 数量 = 1, 广播 = '#C水水谁%s获得了什么#G#m(%s)[%s]#m#n'},
    {几率 = 10, 名称 = '亲密丹', 数量 = 1, 参数 = 1000}
}
function NPC:掉落包(玩家)
    local 银子 = 0
    local 经验 = 50000 * (玩家.等级 * 0.15)
    -- if 玩家:判断等级是否高于(142) and 玩家:判断等级是否低于(90) then --90-142
    --     --玩家:常规提示("#Y适合事件90-142级玩家参与！")
    --     return
    -- end
    玩家:添加参战召唤兽经验(经验 * 1.5)
    玩家:添加银子(银子)
    玩家:添加经验(经验)

    if 玩家:取活动限制次数('李白') > 10 then
        return
    end
    玩家:增加活动限制次数('李白')
    for i, v in ipairs(_掉落) do
        if math.random(1000) <= v.几率 then
            local r = 生成物品 {名称 = v.名称, 数量 = v.数量, 参数 = v.参数}
            if r then
                玩家:添加物品({r})
                if v.广播 then
                    玩家:发送系统(v.广播, 玩家.名称, r.ind, r.名称)
                end
                break
            end
        end
    end
end

return NPC
