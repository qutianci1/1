-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-26 07:12:31
-- @Last Modified time  : 2024-07-31 16:41:00

local 战斗 = {
    是否惩罚 = true --死亡
}

function 战斗:战斗初始化(玩家)
    -- for i = 1, 1 do
    --     local r = 生成战斗怪物 {外形 = 3923, 名称 = 'test' .. i, 原名 = '孟极'}

    --     self:加入敌方(i, r)
    --     r.是否消失 = false
    --     r.气血=1000
    -- end
    for i = 1, 1 do
        local r = 生成战斗怪物 {
            外形 = 2002,
            名称 = 'test' .. i,
            等级 =100,
            攻击 = 1000,
            速度 = 1,
            气血 = 99999999,
            -- 技能 = {'天魔解体_AI'},
            -- 施法几率 = 100 ,
            是否消失 = false,
            抗性={物理吸收=1},
            可以捕捉 = true,
            -- 内丹 = {{ 技能 = "隔山打牛", 转生 = 3, 等级 = 160 }}
            -- AI = {'互相拉血'}
        }
        self:加入敌方(i, r)
    end
end

--熟练度 l*100
function 战斗:战斗回合开始(v)
    -- print('战斗回合开始', v.位置, v.名称)
    -- v:置指令('物理')
    --v.躲闪率 = 100
    --    v.反击率 = 100
    --     v.反击次数 = 9
    -- v.连击率 = 100
    -- v.狂暴几率 = 100
    -- v.致命几率 = 100
    local r = self:取对象(1)
    -- r.反震率 = 100
    -- r.反震程度 = 100
    -- r.连击率 = 100
    -- r.连击次数 = 5
    -- r.躲闪率 = 100
    -- r.物理吸收 = 100

end

function 战斗:战斗回合结束(v)

end

function 战斗:战斗开始(v)


    
end

function 战斗:战斗结束(v)
    local r = self:取对象(11)
    -- print(r.名称)
    for k, v in self:遍历我方() do
        -- print(k, v.对象,v.对象.接口, v.名称, v.是否召唤)
    end
end

return 战斗
