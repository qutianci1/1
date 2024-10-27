-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-27 13:51:21
-- @Last Modified time  : 2024-08-26 13:35:46
--{year =2022, month = 7, day =27, hour =0, min =0, sec = 00}
--年月日 时分秒
local 事件 = {
    名称 = '花灯报吉_天官',
    是否打开 = true,
    开始时间 = os.time {year = 2022, month = 7, day = 25, hour = 0, min = 0, sec = 00},
    结束时间 = os.time {year = 2025, month = 7, day = 30, hour = 0, min = 0, sec = 00}
}

function 事件:事件初始化()
    self.NPC = {}
end

local _地图 = {1208 , 1193}

function 事件:更新()
    for a, b in pairs(_地图) do
        local map = self:取地图(b)
        local X, Y = map:取随机坐标()
        local NPC =
            map:添加NPC {
            名称 = '赐福天官',
            称谓 = '花灯报吉',
            外形 = 2126,
            时间 = 7200,
            脚本 = 'scripts/event/花灯报吉_天官.lua',
            X = X,
            Y = Y,
            事件 = self
        }
    end
    self:发送系统('#G玉帝见诸位不辞劳苦，特派天官下凡来#W东海渔村、长安城东#G犒劳各位，只要成功通过一个考验就能成功得到丰厚奖励哦#97')
    return not self.是否结束 and 1800000
end

function 事件:事件开始()
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
        local r = 玩家:进入战斗('scripts/event/花灯报吉_天官.lua' , self)
        if r then
            self:完成(玩家)
        end
    end
end

--===============================================

function 事件:战斗初始化(玩家 , NPC)
    local 等级 = 玩家:取队伍平均等级()
    local _怪物 = {
        { 名称 = NPC.名称, 外形 = NPC.外形, 等级=等级, 血初值 = 15800, 法初值 = 2000, 攻初值 = 50, 敏初值 = 700 , 技能 = {{名称 = '天诛地灭' , 熟练度 = 25000}} , 施法几率 = 100 , 抗性 = { 忽视抗雷 = 30 , 加强雷 = 40 , 雷系狂暴几率 = 35} , 是否消失 = false},
        { 名称 = "人参娃娃", 外形 = 0048, 等级=等级, 血初值 = 14100, 法初值 = 2000, 攻初值 = 20, 敏初值 = 1100 , 技能 = {{名称 = '含情脉脉' , 熟练度 = 25000}},施法几率 = 50,是否消失 = false},
        { 名称 = "采莲仙童", 外形 = 0047, 等级=等级, 血初值 = 14100, 法初值 = 2000, 攻初值 = 20, 敏初值 = 1100 , 技能 = {{名称 = '九龙冰封' , 熟练度 = 25000}},施法几率 = 50,是否消失 = false},
        { 名称 = "桃花仙", 外形 = 2096, 等级=等级, 血初值 = 15000, 法初值 = 2000, 攻初值 = 20, 敏初值 = 700,施法几率 = 50,是否消失 = false},
        { 名称 = "梅花仙", 外形 = 2100, 等级=等级, 血初值 = 15000, 法初值 = 2000, 攻初值 = 20, 敏初值 = 700,施法几率 = 50,是否消失 = false},
        { 名称 = "貔貅", 外形 = 2041, 等级=等级, 血初值 = 16800, 法初值 = 2000, 攻初值 = 2000, 敏初值 = 900 , 技能 = {{名称 = '吸星大法' , 熟练度 = 25000}},施法几率 = 50,是否消失 = false}
    }
    for i=1,6 do
        local r = {}
        if i == 4 or i == 5 then
            r = 生成战斗怪物(生成怪物属性(_怪物[i],'地狱',nil,'高级法术'))
        elseif i == 1 then
            r = 生成战斗怪物(生成怪物属性(_怪物[i],'炼狱'))
        else
            r = 生成战斗怪物(生成怪物属性(_怪物[i],'地狱'))
        end
        self:加入敌方(i, r)
    end
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
    if 玩家:取活动限制次数('天官') >= 5 then
        玩家:常规提示('本日奖励次数已尽,无法继续获得奖励')
        return
    end
    玩家:增加活动限制次数('天官')
    local 银子 = 33333
    local 经验 = 50000 * (玩家.等级 * 0.15)
    --(1+玩家.其它.鬼王次数*1.2)
    玩家:添加参战召唤兽经验(经验 * 1.5, "天官")
    玩家:添加银子(银子, "天官")
    玩家:添加经验(经验, "天官")
    local 奖励 = 是否奖励(2011,玩家.等级,玩家.转生)
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
