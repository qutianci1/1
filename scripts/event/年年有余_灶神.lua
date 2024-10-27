-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-27 13:51:21
-- @Last Modified time  : 2024-08-23 22:41:49
--{year =2022, month = 7, day =27, hour =0, min =0, sec = 00}
--年月日 时分秒
local 事件 = {
    名称 = '年年有余_灶神',
    是否打开 = true,
    开始时间 = os.time {year = 2022, month = 7, day = 25, hour = 0, min = 0, sec = 00},
    结束时间 = os.time {year = 2025, month = 7, day = 30, hour = 0, min = 0, sec = 00}
}

function 事件:事件初始化()
    self.NPC = {}
end

local _主怪信息 = {
    {名称 = '满嘴流油的灶神', 模型 = 2168},
    {名称 = '东逃西窜的灶神', 模型 = 2168},
    {名称 = '气急败坏的灶神', 模型 = 2168},
    {名称 = '灶神', 模型 = 2168}
}
function 事件:更新()
    local map = self:取地图(1001)
    for k, v in pairs(_主怪信息) do
        for _ = 1, 10 do
            local X, Y = map:取随机坐标()
            local NPC =
                map:添加NPC {
                名称 = v.名称,
                外形 = v.模型,
                时间 = 1800000,
                脚本 = 'scripts/event/年年有余_灶神.lua',
                X = X,
                Y = Y,
                事件 = self
            }
        end
    end

    self:发送系统('#Y【送灶神】#G原是灶神不满年关供奉，将金鲤王掳走。灶神现逃窜在#W长安城内#G，速将其捉拿，解救金鲤王!')
    return not self.是否结束 and 1800000
    --3600000
end

function 事件:事件开始()
    if os.date('%w', os.time()) == '3' then
        self:INFO('灶神活动开始了')
        self:定时(1800000, self.更新)
        -- self:发送世界('灶神活动开始了')
    end
end

function 事件:事件结束()
    self.是否结束 = true
end
--=======================================================
local 对话 = [[没想到我躲在这里，也会被你们发现，休想抓我回去。#4
menu
1|妖孽，受死吧
2|我认错人了
]]
function 事件:NPC对话(玩家, i)
    return 对话
end

function 事件:NPC菜单(玩家, i)
    if i == '1' then
        local r = true
        --玩家:进入战斗('scripts/task/年年有余_灶神.lua')
        if r then
            self:完成(玩家)
        end
    end
end

--===============================================

function 事件:战斗初始化(玩家)
end

function 事件:战斗回合开始(dt)
end

function 事件:战斗结束(x, y)
end
--===============================================
function 事件:完成(玩家)
    if 玩家.是否组队 then
        for _, v in 玩家:遍历队伍() do
            
            self:掉落包(v)
        end
    else
        self:掉落包(玩家)
    end
end

function 事件:掉落包(玩家)
    local 银子 = 0
    local 经验 = 30000 * (玩家.等级 * 0.15)
    --(1+玩家.其它.鬼王次数*1.2)

    if 玩家:判断等级是否高于(142) and 玩家:判断等级是否低于(90) then --90-142
        -- 玩家:常规提示("#Y适合事件90-142级玩家参与！")
        玩家:添加参战召唤兽经验(经验, "年年有余_灶神")
        return
    end
    玩家:添加参战召唤兽经验(经验 * 1.5)
    玩家:添加银子(银子)
    玩家:添加经验(经验)

    if 玩家:取活动限制次数('夺镖任务') > 200 then
        return
    end
    玩家:增加活动限制次数('夺镖任务')
    local 奖励 = 是否奖励(2005,玩家.等级,玩家.转生)
    if 奖励 ~= nil and type(奖励) == 'table' then
        local r = 生成物品 { 名称 = 奖励.道具信息.道具, 数量 = 奖励.道具信息.数量, 参数 = 奖励.道具信息.参数 }
        if r then
            玩家:添加物品({ r })
            if 奖励.道具信息.是否广播 == 1 and 奖励.广播 ~= nil then
                玩家:发送系统(奖励.广播, 玩家.名称, r.ind, r.名称)
            end
        end
    end
end

return 事件