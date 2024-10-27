-- @Autho  : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-26 07:12:31
-- @Last Modified time  : 2022-08-01 13:05:50

local 战斗 = {}

function 战斗:战斗初始化(玩家)
    for i = 1, 3 do
        local r = 生成战斗怪物 {外形 = 2, 名称 = '李白' .. i, 原名 = '兔妖'}
        self:加入左方(i, r)
    end
end

function 战斗:战斗回合开始(dt)


    
end

function 战斗:战斗结束(x, y)
end

return 战斗
