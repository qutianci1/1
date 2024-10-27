-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-25 17:16:26
-- @Last Modified time  : 2024-07-30 23:47:30

local 战斗数据 = class('战斗数据')

function 战斗数据:初始化(位置)
    self.位置 = 位置
end

function 战斗数据:物理攻击(位置, 目标)
    table.insert(self, { 动作 = '物攻', 位置 = 位置, 目标 = 目标 })
    return self
end

function 战斗数据:物理伤害(数值, 防御, 死亡, 消失)
    local t = { 动作 = '物伤', 数值 = 数值, 防御 = 防御, 死亡 = 死亡, 消失 = 消失 }
    table.insert(self, t)
    return t
end

function 战斗数据:物理反击(目标)
    table.insert(self, { 动作 = '物反', 目标 = 目标 })
    return self
end

function 战斗数据:物理法术(法术, 目标)
    self[#self].附法 = { 动作 = '附法', id = 法术, 目标 = 目标 }

    return self
end

function 战斗数据:法术(法术, 目标)
    table.insert(self, { 动作 = '法术', id = 法术, 目标 = 目标 })
    return self
end

function 战斗数据:法术后(目标)
    table.insert(self, { 动作 = '法术后', 目标 = 目标 })
    return self
end

function 战斗数据:法术伤害(数值, 死亡, 消失)
    local t = { 动作 = '法伤', 数值 = 数值, 死亡 = 死亡, 消失 = 消失 }
    table.insert(self, t)
    return t

    -- table.insert(self, { 动作 = '法伤', 数值 = 数值, 死亡 = 死亡, 消失 = 消失 })
    -- return self
end

function 战斗数据:道具(目标)
    table.insert(self, { 动作 = '道具', 目标 = 目标 })
    return self
end

function 战斗数据:召唤(数据)
    table.insert(self, { 动作 = '召唤', 数据 = 数据 })
    return self
end

function 战斗数据:召还(位置)
    table.insert(self, { 动作 = '召还', 位置 = 位置 })
    return self
end

function 战斗数据:捕捉(目标, 结果)
    table.insert(self, { 动作 = '捕捉', 目标 = 目标, 结果 = 结果 })
    return self
end

function 战斗数据:逃跑(结果)
    table.insert(self, { 动作 = '逃跑', 结果 = 结果 })
    return self
end

function 战斗数据:提示(内容)
    table.insert(self, { 动作 = '提示', 内容 = 内容 })
    return self
end

function 战斗数据:喊话(内容)
    table.insert(self, { 动作 = '喊话', 内容 = 内容 })
    return self
end

function 战斗数据:气血(数值, 特效 , 死亡)
    table.insert(self, { 动作 = '气血', 数值 = 数值, 特效 = 特效 , 死亡 = 死亡 })
    return self
end

function 战斗数据:魔法(数值, 特效, 显示)
    table.insert(self, { 动作 = '魔法', 数值 = 数值, 特效 = 特效, 显示 = 显示 })
    return self
end

function 战斗数据:死亡(消失)
    table.insert(self, { 动作 = '死亡', 消失 = 消失 })
    return self
end

function 战斗数据:复活()
    table.insert(self, { 动作 = '复活' })
    return self
end

function 战斗数据:添加BUFF(id)
    table.insert(self, { 动作 = '加BF', id = id })
    return self
end

function 战斗数据:删除BUFF(id)
    table.insert(self, { 动作 = '减BF', id = id })
    return self
end

return 战斗数据
