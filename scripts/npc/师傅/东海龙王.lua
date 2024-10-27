-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-06-13 08:38:04
-- @Last Modified time  : 2023-08-27 22:24:17

local NPC = {}
local 对话1 = [[别学会了法术就胡作为非,败坏了为师得名声，那种徒弟我收得多了。
menu
1|我要学习师门技能
2|我想要回长安
]]

local 对话2 = [[别学会了法术就胡作为非,败坏了为师得名声，那种徒弟我收得多了。
menu
2|我想要回长安
]]

local 对话3 = [[别学会了法术就胡作为非,败坏了为师得名声，那种徒弟我收得多了。
menu
1|我要学习师门技能
2|我想要回长安
3|夺宝
]]

local 对话4 = [[别学会了法术就胡作为非,败坏了为师得名声，那种徒弟我收得多了。
menu
2|我想要回长安
3|夺宝
]]
--其它对话
function NPC:NPC对话(玩家, i)
    if 玩家.种族 == 3 then
        if os.date('%w', os.time()) == '6' or os.date('%w', os.time()) == '0' then
            return 对话3
        else
            return 对话1
        end
    else
        if os.date('%w', os.time()) == '6' or os.date('%w', os.time()) == '0' then
            return 对话4
        else
            return 对话2
        end
    end
end
local _smjn = { '龙卷雨击', '龙腾水溅', '龙啸九天', '蛟龙出海', '九龙冰封' }
function NPC:NPC菜单(玩家, i)
    if i == '2' then
        玩家:切换地图(1001, 380, 12)
    elseif i == '1' then
        local r = self:技能选项(玩家)
        if r then
            return "你进入门派也有一些日子了,学习一下新技能吧！\nmenu\n5|" .. r
        else
            return "你已经学会了所有门派技能"
        end
    elseif i == '3' then
        if os.date('%w', os.time()) == '6' or os.date('%w', os.time()) == '0' then
            if 玩家:取活动限制次数('挑战龙王') > 5 then
                玩家:常规提示('本日奖励次数已尽,无法继续获得奖励')
                return
            end
            local v = 玩家:进入战斗('scripts/war/战斗_龙王.lua')
            if v then
                玩家:增加活动限制次数('挑战龙王')
                local 银子 = 0
                local 经验 = 5000
                玩家:添加银子(银子)
                玩家:添加任务经验(经验)
                if 玩家:检查空位() then--这里调用的奖励池是 服务端/data下的奖励池,不要改错
                    local 奖励 = 是否奖励(2002,玩家.等级,玩家.转生)
                    if 奖励 ~= nil and type(奖励) == 'table' then
                        local r = 生成物品 { 名称 = 奖励.道具信息.道具, 数量 = 奖励.道具信息.数量, 参数 = 奖励.道具信息.参数 }
                        if r then
                            玩家:添加物品({ r })
                            if 奖励.道具信息.是否广播 == 1 and 奖励.广播 ~= nil then
                                玩家:发送系统(奖励.广播, 玩家.名称, r.ind, r.名称)
                            end
                        end
                    end
                else
                    return '你的物品栏已满,无法继续获得物品'
                end
            end
        end
    end
end

function NPC:技能选项(玩家)
    for k, v in ipairs(_smjn) do
        if not 玩家:取技能是否存在(v) then
            return v
        end
    end
end

return NPC
