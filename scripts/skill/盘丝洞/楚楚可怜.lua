-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-06 19:05:22
-- @Last Modified time  : 2023-05-09 06:54:57

local 法术 = {
    类别 = '门派',
    类型 = 1,
    对象 = 1,
    条件 = 37,
    名称 = '楚楚可怜',
    id = 903,
}

local BUFF
function 法术:法术施放(攻击方, 目标)
    local 消耗mp = self:法术取消耗().消耗MP
    if 攻击方.魔法 < 消耗mp then
        攻击方:提示("#R魔法不足，无法释放！")
        return false
    end
    self.xh = 消耗mp
    for _, v in ipairs(目标) do
        v:被使用法术(攻击方, self)
        local b = v:添加BUFF(BUFF)
        if b then
            b.回合 = self:法术取回合()
            b.效果 = self:法术取BUFF效果(攻击方, v)
        end
    end
end
function 法术:法术施放后(攻击方, 目标)
    if self.xh then
        攻击方:减少魔法(self.xh)
        self.xh=false
    end
end
function 法术:法术取BUFF效果(攻击方, 挨打方)
    local 效果 = { 抗雷 = 0, 抗火 = 0, 抗水 = 0, 抗风 = 0, 物理吸收 = 0, 抗昏睡 = 0, 抗中毒 = 0,
        抗混乱 = 0, 抗封印 = 0 }
    local 临时法抗,临时人抗=self:取仙法(),self:取人法()
    临时法抗=临时法抗*(1+攻击方.加强加防法术/100)
    临时人抗=临时人抗*(1+攻击方.加强加防法术/100)

    效果.抗雷 = 临时法抗
    效果.抗火 = 临时法抗
    效果.抗水 = 临时法抗
    效果.抗风 = 临时法抗
    效果.物理吸收 = 临时法抗
    效果.抗昏睡 = 临时人抗
    效果.抗中毒 = 临时人抗
    效果.抗混乱 = 临时人抗
    效果.抗封印 = 临时人抗
    for k, v in pairs(效果) do
        挨打方.抗性[k] = 挨打方.抗性[k] + v
    end

    return 效果
end

function 法术:法术取回合()
    if self.熟练度 >= 19000 then
        return 7
    elseif self.熟练度 >= 12000 then
        return 6
    elseif self.熟练度 >= 6800 then
        return 5
    elseif self.熟练度 >= 3000 then
        return 4
    elseif self.熟练度 >= 1200 then
        return 3
    else
        return 2
    end
end

function 法术:法术取目标数()
    if self.熟练度 >= 8324 then
        return 5
    elseif self.熟练度 >= 2155 then
        return 4
    elseif self.熟练度 >= 214 then
        return 3
    else
        return 2
    end
end

function 法术:法术取消耗()
    return { 消耗MP = math.floor(self.熟练度 * 0.178) }
end

function 法术:取人法()
    local 临时人抗=4+self.熟练度*0.00016
    return 临时人抗
end

function 法术:取仙法()
    local 临时法抗=0
    if self.熟练度>=25000 then
        临时法抗=33.8+(self.熟练度-25000)*0.00015
    elseif self.熟练度>=20000 then
        临时法抗=32.8+(self.熟练度-20000)*0.0002
    elseif self.熟练度>=15000 then
        临时法抗=31.6+(self.熟练度-15000)*0.00024
    elseif self.熟练度>=10000 then
        临时法抗=30.1+(self.熟练度-10000)*0.0003
    elseif self.熟练度>=5000 then
        临时法抗=27.9+(self.熟练度-5000)*0.00044
    else
        临时法抗=20.4+self.熟练度*0.0015
    end
    return 临时法抗
end

function 法术:法术取描述()
    return string.format('增加物理吸收和仙族四系法术抗性#R%s%%#G,增加人族法术抗性#R%s%%#G,使用范围#R%s#G人，持续效果#R%s#G个回合。' ,string.format("%.2f",self:取仙法()),string.format("%.2f",self:取人法()), self:法术取目标数(), self:法术取回合())
end

BUFF = {
    法术 = '楚楚可怜',
    名称 = '盘',
    id = 903
}
法术.BUFF = BUFF
function BUFF:BUFF回合结束(单位)
    if self.回合数 >= self.回合 then
        self:删除()
        for k, v in pairs(self.效果) do
            单位.抗性[k] = 单位.抗性[k] - v
        end
    end
end

return 法术
