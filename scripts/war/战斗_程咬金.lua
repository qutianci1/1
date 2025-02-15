-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-08-26 02:04:28
-- @Last Modified time  : 2023-08-27 04:49:46

local 战斗 = {}

function 战斗:战斗初始化(玩家)
    local _技能 = { {名称 = '袖里乾坤' , 熟练度 = 20000} , {名称 = '九阴纯火' , 熟练度 = 20000} , {名称 = '天诛地灭' , 熟练度 = 20000} , {名称 = '九龙冰封' , 熟练度 = 20000} , {名称 = '阎罗追命' , 熟练度 = 20000} }
    local _怪物 = {
        [1] = {名称 = '程咬金' , 外形 = 2083 , 等级 = 10 , 血初值 = 14000 , 法初值 = 300 , 攻初值 = 50 , 敏初值 = 600 , 技能 = { {名称 = '四面楚歌' , 熟练度 = 10000} , {名称 = '作壁上观' , 熟练度 = 10000} } , 施法几率 = 80 , 抗性 = { 抗风 = 10 , 抗雷 = 10 , 抗水 = 10 , 抗火 = 10 , 抗混乱 = 100 , 抗昏睡 = 100 , 抗封印 = 100 , 抗遗忘 = 80 , 抗震慑 = 30 , 物理吸收 = 30 , 抗致命几率 = 25 , 反震率 = 80 , 反震程度 = 60} },
        [2] = {名称 = '程小晶' , 外形 = 3 , 等级 = 10 , 血初值 = 14000 , 法初值 = 300 , 攻初值 = 500 , 敏初值 = 300 , 技能 = { {名称 = '断肠烈散' , 熟练度 = 10000} , {名称 = '万毒攻心' , 熟练度 = 10000} , {名称 = '百日眠' , 熟练度 = 10000} } , 施法几率 = 80 , 抗性 = { 抗混乱 = 90 , 抗昏睡 = 90 , 抗封印 = 90 , 抗遗忘 = 80 , 抗震慑 = 10 , 物理吸收 = 30 , 抗致命几率 = 25 } },
        [3] = {名称 = '跟班' , 外形 = 2130 , 等级 = 10 , 血初值 = 14000 , 法初值 = 300 , 攻初值 = 700 , 敏初值 = 200 , 技能 = {} , 抗性 = { 抗风 = 20 , 抗雷 = 20 , 抗水 = 20 , 抗火 = 20 , 抗混乱 = 90 , 物理吸收 = 60 , 连击率 = 70 , 狂暴几率 = 40 , 致命几率 = 40 , 连击次数 = 4 , 忽视防御几率 = 80 , 忽视防御程度 = 100 , 抗致命几率 = 15 } },
        [4] = {名称 = '跟班' , 外形 = 2130 , 等级 = 10 , 血初值 = 14000 , 法初值 = 300 , 攻初值 = 700 , 敏初值 = 200 , 技能 = {} , 抗性 = { 抗风 = 20 , 抗雷 = 20 , 抗水 = 20 , 抗火 = 20 , 抗混乱 = 90 , 物理吸收 = 60 , 连击率 = 70 , 狂暴几率 = 40 , 致命几率 = 40 , 连击次数 = 4 , 忽视防御几率 = 80 , 忽视防御程度 = 100 , 抗致命几率 = 15 } }
    }
    for i = 1, 4 do
        _怪物[i].等级 = 玩家.等级 + 20
        if _怪物[i].等级 < 100 then
            _怪物[i].等级 = 100
        end
        local r = 生成战斗怪物( 生成怪物属性( _怪物[i] ) )
        self:加入敌方(i, r)
    end
end

function 战斗:战斗回合开始(dt)
end

function 战斗:战斗结束(x, y)
end

return 战斗
