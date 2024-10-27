-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-27 13:51:21
-- @Last Modified time  : 2024-08-26 13:35:15
--{year =2022, month = 7, day =27, hour =0, min =0, sec = 00}
--年月日 时分秒
local 事件 = {
    名称 = '城东BOSS',
    是否打开 = true,
    开始时间 = os.time {year = 2022, month = 7, day = 25, hour = 0, min = 0, sec = 00},
    结束时间 = os.time {year = 2025, month = 7, day = 30, hour = 0, min = 0, sec = 00}
}

function 事件:事件初始化()
    self.NPC = {}
end

local _主怪信息 = {
    [1] = {名称 = '东海东王', 模型 = 3074}
}
function 事件:更新()
    local map = self:取地图(1193)
    for i = 1, #_主怪信息 do
        for _ = 1, 20 do
            local X, Y = map:取随机坐标()
            local NPC =
                map:添加NPC {
                名称 = _主怪信息[i].名称,
                外形 = _主怪信息[i].模型,
                时间 = 14400,
                脚本 = 'scripts/event/城东BOSS.lua',
                X = X,
                Y = Y,
                事件 = self
            }
        end
        self:发送系统('#Y【城东卫战】#G%s#W在#R长安东#G向#R长安城#G发起进攻，唐王下令全体军民誓死抵御来犯之敌#90#G犯我中华者虽远必诛#90', _主怪信息[i].名称)
    end

    return not self.是否结束 and 1800000
end

function 事件:事件开始()
    if os.date('%w', os.time()) == '2' then
        self:INFO('城东保卫战boss活动开始了')
        self:定时(1800000, self.更新)
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
        local r = 玩家:进入战斗('scripts/event/城东BOSS.lua' , self)
        if r then
            self:完成(玩家)
            self:删除()
        end
    end
end

--===============================================

function 事件:战斗初始化(玩家 , NPC)
    local 等级 = 玩家:取队伍平均等级() + 20
    local _怪物 = {
        { 名称 = NPC.名称, 外形 = 14, 等级=等级, 血初值 = 18000, 法初值 = 50, 攻初值 = 300, 敏初值 = 1200,    技能 = {{名称 = '九龙冰封',熟练度 = 25000},{名称 = '天诛地灭',熟练度 = 25000}} , 抗性 = {忽视抗水 = 25 , 忽视抗雷 = 25 , 加强水 = 35 , 加强雷 = 35 , 水系狂暴几率 = 25 , 雷系狂暴几率 = 25} , 施法几率 = 100,是否消失 = false},
        { 名称 = "凌波儿", 外形 = 2108, 等级=等级, 血初值 = 21000, 法初值 = 50, 攻初值 = 300, 敏初值 = 600,         技能 = {{名称 = '电闪雷鸣',熟练度 = 25000}}, 抗性 = {忽视抗雷 = 100 , 加强雷 = 100 , 雷系狂暴几率 = 100} , 施法几率 = 100,是否消失 = false , 内丹 = {{ 技能 = "凌波微步", 转生 = 2, 等级 = 140 }}},
        { 名称 = "凌波儿", 外形 = 2108, 等级=等级, 血初值 = 21000, 法初值 = 50, 攻初值 = 300, 敏初值 = 600,         技能 = {{名称 = '电闪雷鸣',熟练度 = 25000}}, 抗性 = {忽视抗雷 = 100 , 加强雷 = 100 , 雷系狂暴几率 = 100} , 施法几率 = 100,是否消失 = false , 内丹 = {{ 技能 = "凌波微步", 转生 = 2, 等级 = 140 }}},
        { 名称 = "龙战将", 外形 = 14, 等级=等级, 血初值 = 16000, 法初值 = 50, 攻初值 = 300, 敏初值 = 1200,          技能 = {{名称 = '风雷涌动',熟练度 = 25000},{名称 = '袖里乾坤',熟练度 = 25000}} , 抗性 = {忽视抗风 = 25 , 加强风 = 20 } , 施法几率 = 100,是否消失 = false , 内丹 = {{ 技能 = "乘风破浪", 转生 = 2, 等级 = 140 }}},
        { 名称 = "凌波儿", 外形 = 2108, 等级=等级, 血初值 = 21000, 法初值 = 800, 攻初值 = 300, 敏初值 = 600,        技能 = {{名称 = '电闪雷鸣',熟练度 = 25000}}, 抗性 = {忽视抗雷 = 100 , 加强雷 = 100 , 雷系狂暴几率 = 100} , 施法几率 = 100,是否消失 = false , 内丹 = {{ 技能 = "凌波微步", 转生 = 2, 等级 = 140 }}},
        { 名称 = "龙战将", 外形 = 14, 等级=等级, 血初值 = 16000, 法初值 = 50, 攻初值 = 300, 敏初值 = 1200,          技能 = {{名称 = '风雷涌动',熟练度 = 25000},{名称 = '袖里乾坤',熟练度 = 25000}} , 抗性 = {忽视抗风 = 25 , 加强风 = 20 } , 施法几率 = 100,是否消失 = false , 内丹 = {{ 技能 = "乘风破浪", 转生 = 2, 等级 = 140 }}},
        { 名称 = "泾河龙鬼", 外形 = 2076, 等级=等级, 血初值 = 14500, 法初值 = 50, 攻初值 = 300, 敏初值 = 1400,      技能 = {{名称 = '乾坤借速',熟练度 = 25000},{名称 = '阎罗追命',熟练度 = 25000}},施法几率 = 100,是否消失 = false , 内丹 = {{ 技能 = "凌波微步", 转生 = 2, 等级 = 140 }}},
        { 名称 = "龙战将", 外形 = 14, 等级=等级, 血初值 = 16000, 法初值 = 50, 攻初值 = 300, 敏初值 = 1200,          技能 = {},施法几率 = 0,是否消失 = false , 内丹 = {{ 技能 = "隔山打牛", 转生 = 2, 等级 = 140 } , { 技能 = "浩然正气", 转生 = 2, 等级 = 140 } , { 技能 = "借力打力", 转生 = 2, 等级 = 140 }}},
        { 名称 = "泾河龙鬼", 外形 = 2076, 等级=等级, 血初值 = 14500, 法初值 = 50, 攻初值 = 300, 敏初值 = 1400,      技能 = {{名称 = '乾坤借速',熟练度 = 25000},{名称 = '阎罗追命',熟练度 = 25000}},施法几率 = 100,是否消失 = false , 内丹 = {{ 技能 = "凌波微步", 转生 = 2, 等级 = 140 }}},
        { 名称 = "泾河龙鬼", 外形 = 2076, 等级=等级, 血初值 = 14500, 法初值 = 50, 攻初值 = 300, 敏初值 = 1400,      技能 = {{名称 = '乾坤借速',熟练度 = 25000},{名称 = '阎罗追命',熟练度 = 25000}},施法几率 = 100,是否消失 = false , 内丹 = {{ 技能 = "凌波微步", 转生 = 2, 等级 = 160 }}},
    }
    for i=1,10 do
        local r = {}
        if i == 1 then
            r = 生成战斗怪物(生成怪物属性(_怪物[i],'炼狱'))
        elseif i == 8 then
            r = 生成战斗怪物(生成怪物属性(_怪物[i],'困难'))
            r.抗性.连击率 = 80
            r.抗性.连击次数 = 8
            r.抗性.狂暴几率 = 60
            r.抗性.致命几率 = 60
            r.抗性.忽视防御几率 = 100
            r.抗性.忽视防御程度 = 80
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
    if 玩家:取活动限制次数('城东BOSS') >= 5 then
        玩家:提示窗口('本日奖励次数已尽,无法继续获得奖励')
        return
    end
    玩家:增加活动限制次数('城东BOSS')
    local 银子 = 33333
    local 经验 = 30000 * (玩家.等级 * 0.15)
    --(1+玩家.其它.鬼王次数*1.2)
    玩家:添加参战召唤兽经验(经验 * 1.5, "城东BOSS")
    玩家:添加银子(银子, "城东BOSS")
    玩家:添加经验(经验, "城东BOSS")
    local 奖励 = 是否奖励(2008,玩家.等级,玩家.转生)
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
