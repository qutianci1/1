-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-08-08 23:30:06
-- @Last Modified time  : 2022-08-09 01:24:40

local 战斗物品 = class('战斗物品')

function 战斗物品:初始化(物品)
    self.物品 = 物品
    self.脚本 = 物品.脚本
end

function 战斗物品:__index(k)
    local t = rawget(self, '道具')
    if t then
        return t[k]
    end
end

function 战斗物品:使用(dst)
end

return 战斗物品
