-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-08-26 02:04:28
-- @Last Modified time  : 2023-08-26 04:45:41

local 战斗 = {}

function 战斗:战斗初始化(玩家)
    local _技能 = {
        [1] = { {名称 = '三味真火' , 熟练度 = 20000} , {名称 = '烈火骄阳' , 熟练度 = 20000} , {名称 = '九阴纯火' , 熟练度 = 20000} }
    }
    local _怪物 = {
        [1] = {名称 = '火德星君' , 外形 = 54 , 等级 = 10 , 血初值 = 100000 , 法初值 = 300 , 攻初值 = 500 , 敏初值 = 400 , 技能 = {{名称 = '互相拉血' , 熟练度 = 1} , {名称 = '血海深仇' , 熟练度 = 25000}} , 施法几率 = 100 , 抗性 = {抗风 = 200 , 抗雷 = 200 , 抗水 = 200 , 抗火 = 200 , 抗混乱 = 200 , 抗昏睡 = 200 , 抗封印 = 200 , 抗遗忘 = 200 , 抗震慑 = 200 , 物理吸收 = 200 , 躲闪率 = 200 , 鬼火狂暴几率 = 100 , 鬼火狂暴程度 = 500 , 忽视抗鬼火 = 300} },
        [2] = {名称 = '喷火牛' , 外形 = 2104 , 等级 = 10 , 血初值 = 8000 , 法初值 = 300 , 攻初值 = 500 , 敏初值 = 600 , 技能 = _技能[1] , 施法几率 = 100 , 抗性 = {抗风 = 10 , 抗雷 = 10 , 抗水 = 10 , 抗火 = 30 , 抗混乱 = 100 , 抗昏睡 = 100 , 抗封印 = 70 , 抗遗忘 = 100 , 抗鬼火 = 10 , 抗震慑 = 10 , 物理吸收率 = 30 , 抗致命几率 = 20 , 火系狂暴几率 = 30 , 加强火 = 20 } },
        [3] = {名称 = '喷火牛' , 外形 = 2104 , 等级 = 10 , 血初值 = 8000 , 法初值 = 300 , 攻初值 = 500 , 敏初值 = 600 , 技能 = _技能[1] , 施法几率 = 100 , 抗性 = {抗风 = 10 , 抗雷 = 10 , 抗水 = 10 , 抗火 = 30 , 抗混乱 = 100 , 抗昏睡 = 100 , 抗封印 = 70 , 抗遗忘 = 100 , 抗鬼火 = 10 , 抗震慑 = 10 , 物理吸收率 = 30 , 抗致命几率 = 20 , 火系狂暴几率 = 30 , 加强火 = 20 } },
        [4] = {名称 = '凤凰' , 外形 = 2071 , 等级 = 10 , 血初值 = 8000 , 法初值 = 300 , 攻初值 = 500 , 敏初值 = 600 , 技能 = _技能[1] , 施法几率 = 100 , 抗性 = {抗风 = 10 , 抗雷 = 10 , 抗水 = 10 , 抗火 = 30 , 抗混乱 = 100 , 抗昏睡 = 100 , 抗封印 = 70 , 抗遗忘 = 100 , 抗鬼火 = 10 , 抗震慑 = 10 , 物理吸收率 = 30 , 抗致命几率 = 20 , 火系狂暴几率 = 30 , 加强火 = 20 } },
        [5] = {名称 = '凤凰' , 外形 = 2071 , 等级 = 10 , 血初值 = 8000 , 法初值 = 300 , 攻初值 = 500 , 敏初值 = 600 , 技能 = _技能[1] , 施法几率 = 100 , 抗性 = {抗风 = 10 , 抗雷 = 10 , 抗水 = 10 , 抗火 = 30 , 抗混乱 = 100 , 抗昏睡 = 100 , 抗封印 = 70 , 抗遗忘 = 100 , 抗鬼火 = 10 , 抗震慑 = 10 , 物理吸收率 = 30 , 抗致命几率 = 20 , 火系狂暴几率 = 30 , 加强火 = 20 } },
        [6] = {名称 = '赤焰妖' , 外形 = 2103 , 等级 = 10 , 血初值 = 8000 , 法初值 = 300 , 攻初值 = 500 , 敏初值 = 600 , 技能 = _技能[1] , 施法几率 = 100 , 抗性 = {抗风 = 10 , 抗雷 = 10 , 抗水 = 10 , 抗火 = 30 , 抗混乱 = 100 , 抗昏睡 = 100 , 抗封印 = 70 , 抗遗忘 = 100 , 抗鬼火 = 10 , 抗震慑 = 10 , 物理吸收率 = 30 , 抗致命几率 = 20 , 火系狂暴几率 = 30 , 加强火 = 20 } },
        [7] = {名称 = '赤焰妖' , 外形 = 2103 , 等级 = 10 , 血初值 = 8000 , 法初值 = 300 , 攻初值 = 500 , 敏初值 = 600 , 技能 = _技能[1] , 施法几率 = 100 , 抗性 = {抗风 = 10 , 抗雷 = 10 , 抗水 = 10 , 抗火 = 30 , 抗混乱 = 100 , 抗昏睡 = 100 , 抗封印 = 70 , 抗遗忘 = 100 , 抗鬼火 = 10 , 抗震慑 = 10 , 物理吸收率 = 30 , 抗致命几率 = 20 , 火系狂暴几率 = 30 , 加强火 = 20 } },
        [8] = {名称 = '赤焰妖' , 外形 = 2103 , 等级 = 10 , 血初值 = 8000 , 法初值 = 300 , 攻初值 = 500 , 敏初值 = 600 , 技能 = _技能[1] , 施法几率 = 100 , 抗性 = {抗风 = 10 , 抗雷 = 10 , 抗水 = 10 , 抗火 = 30 , 抗混乱 = 100 , 抗昏睡 = 100 , 抗封印 = 70 , 抗遗忘 = 100 , 抗鬼火 = 10 , 抗震慑 = 10 , 物理吸收率 = 30 , 抗致命几率 = 20 , 火系狂暴几率 = 30 , 加强火 = 20 } },
        [9] = {名称 = '凤凰' , 外形 = 2071 , 等级 = 10 , 血初值 = 8000 , 法初值 = 300 , 攻初值 = 500 , 敏初值 = 600 , 技能 = _技能[1] , 施法几率 = 100 , 抗性 = {抗风 = 10 , 抗雷 = 10 , 抗水 = 10 , 抗火 = 30 , 抗混乱 = 100 , 抗昏睡 = 100 , 抗封印 = 70 , 抗遗忘 = 100 , 抗鬼火 = 10 , 抗震慑 = 10 , 物理吸收率 = 30 , 抗致命几率 = 20 , 火系狂暴几率 = 30 , 加强火 = 20 } },
        [10] = {名称 = '凤凰' , 外形 = 2071 , 等级 = 10 , 血初值 = 8000 , 法初值 = 300 , 攻初值 = 500 , 敏初值 = 600 , 技能 = _技能[1] , 施法几率 = 100 , 抗性 = {抗风 = 10 , 抗雷 = 10 , 抗水 = 10 , 抗火 = 30 , 抗混乱 = 100 , 抗昏睡 = 100 , 抗封印 = 70 , 抗遗忘 = 100 , 抗鬼火 = 10 , 抗震慑 = 10 , 物理吸收率 = 30 , 抗致命几率 = 20 , 火系狂暴几率 = 30 , 加强火 = 20 } },
    }
    for i = 1, 10 do
        _怪物[i].等级 = 玩家.等级 + 20
        if _怪物[i].等级 < 100 then
            _怪物[i].等级 = 100
        end
        local r = 生成战斗怪物(生成怪物属性(_怪物[i] ))
        self:加入敌方(i, r)
    end
end

function 战斗:战斗回合开始(dt)
end

function 战斗:战斗结束(x, y)
end

return 战斗
