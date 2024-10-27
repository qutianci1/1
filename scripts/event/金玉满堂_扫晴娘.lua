-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-27 13:51:21
-- @Last Modified time  : 2024-08-23 22:22:05
--{year =2022, month = 7, day =27, hour =0, min =0, sec = 00}
--年月日 时分秒
local 事件 = {
    名称 = '金玉满堂_扫晴娘',
    是否打开 = true,
    开始时间 = os.time {year = 2022, month = 7, day = 25, hour = 0, min = 0, sec = 00},
    结束时间 = os.time {year = 2025, month = 7, day = 30, hour = 0, min = 0, sec = 00}
}

function 事件:事件初始化()
    self.NPC = {}
end
local _地图 = {1194, 1174, 1092, 1070}
local _主怪信息 = {
    {名称 = '晴娘', 模型 = 2107},
    {名称 = '晴娘', 模型 = 2113}
}

function 事件:更新()
    for k, v in pairs(_地图) do
        local map = self:取地图(v)
        for _ = 1, 100 do
            local X, Y = map:取随机坐标()
            local xz = math.random(#_主怪信息)
            local NPC =
                map:添加NPC {
                名称 = _主怪信息[xz].名称,
                外形 = _主怪信息[xz].模型,
                时间 = 3600,
                脚本 = 'scripts/event/金玉满堂_扫晴娘.lua',
                X = X,
                Y = Y,
                事件 = self
            }
        end
    end

    self:发送系统('#G晴娘出现在#W北俱芦洲，五指山，长寿村，傲来国，长寿村外#G想知道一会是晴天还是阴天的朋友不如赶紧去找晴娘请教请教#132。')

    return not self.是否结束 and 3600
end

function 事件:事件开始()
    if os.date('%w', os.time()) == '6' or os.date('%w', os.time()) == '0' then
        self:INFO('金玉满堂_扫晴娘开始了')
        self:定时(3600, self.更新)
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
        --玩家:进入战斗('scripts/task/天元盛典_万仙方阵.lua')
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
        玩家:添加参战召唤兽经验(经验, "金玉满堂_扫晴娘")
        return
    end
    玩家:添加参战召唤兽经验(经验 * 1.5, "天官")
    玩家:添加银子(银子, "天官")
    玩家:添加经验(经验, "天官")

    if 玩家:取活动限制次数('小金鲤') > 200 then
        return
    end
    玩家:增加活动限制次数('小金鲤')
    local 奖励 = 是否奖励(2012,玩家.等级,玩家.转生)
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
