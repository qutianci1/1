-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-07-28 08:41:42
-- @Last Modified time  : 2023-04-27 19:11:22
local GGF = require('GGE.函数')
local MYF = require('我的函数')

local 怪物 = class('怪物', require('对象/召唤/召唤'))
function 怪物:初始化(t)
    for k, v in pairs(t) do
        self[k] = v
    end

    self.最大魔法 = self.魔法
    self.最大气血 = self.气血
    self.抗性 = MYF.容错表(self.抗性)
    if type(self.技能) == 'table' then
        local 技能 = {}
        for _, v in ipairs(self.技能) do
            if type(v) == 'string' then
                table.insert(技能, require('对象/法术/技能')({ 名称 = v }))
            elseif type(v) == 'table' and v.名称 then
                table.insert(技能, require('对象/法术/技能')(v))
            end
        end
        self.技能 = 技能
    else
        self.技能 = {}
    end

    if type(self.内丹) == 'table' then
        local 内丹 = {}
        for _, v in ipairs(self.内丹) do
            if type(v) == 'string' then
                table.insert(内丹, require('对象/法术/内丹')({ 技能 = v }))
            elseif type(v) == 'table' then
                table.insert(内丹, require('对象/法术/内丹')(v))
            end
        end
        self.内丹 = 内丹
    else
        self.内丹 = {}
    end
end

function 怪物:更新(t)


end

function 怪物:战斗_开始()


end

function 怪物:战斗_结束(v)

end

return 怪物
