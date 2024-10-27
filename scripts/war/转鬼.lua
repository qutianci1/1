-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-26 07:12:31
-- @Last Modified time  : 2024-08-01 21:53:31

local 战斗 = {
    是否惩罚 = true --死亡
}

function 战斗:战斗初始化(玩家)
    local _名称 = {'金','银','铜','铁'}
    local _外形 = {2055,2055,2072,2073}
    local _技能 = {{'雷神怒击' , '电闪雷鸣' , '天诛地灭'},{'魔音摄心' , '狮王之怒'},{'借刀杀人'},{}}
    local _怪物 = {}
    for i = 1, 4 do
        _怪物[i] = {外形 = _外形[i], 名称 = _名称[i], 等级 = 100, 攻击 = 6000 , 速度 = 300, 气血 = 1000000, 技能 = _技能[i], 是否消失 = false, 抗性={物理吸收 = 50 , 抗混乱 = 70 , 抗昏睡 = 60}, 可以捕捉 = false}
        if i == 4 then
            _怪物[i].攻击 = 18000
        end
        local r = 生成战斗怪物 (_怪物[i])
        self:加入敌方(i, r)
    end
end

--熟练度 l*100
function 战斗:战斗回合开始(v)
end

function 战斗:战斗回合结束(v)

end

function 战斗:战斗开始(v)



end

function 战斗:战斗结束(v)
    if v then
        for k, v in self:遍历我方() do
            if v.是否玩家 then
                v.对象.接口:添加物品({生成物品 {名称 = '冥钞', 数量 = 1}})
            end
        end
    end
end

return 战斗
