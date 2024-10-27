-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2023-04-06 19:05:22
-- @Last Modified time  : 2024-08-15 20:56:21

local 法术 = {
    类别 = '门派',
    类型 = 1,
    对象 = 1,
    条件 = 37,
    名称 = '魔神附身',
    id = 1005,
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
    local 效果 = { 命中率 = 15, 攻击 = 0 }
    local 攻击加成=0
    if self.熟练度>=25000 then
        攻击加成=0.819+(self.熟练度-25000)*0.00062/100
    elseif self.熟练度>=20000 then
        攻击加成=0.78+(self.熟练度-20000)*0.00078/100
    elseif self.熟练度>=15000 then
        攻击加成=0.734+(self.熟练度-15000)*0.00092/100
    elseif self.熟练度>=10000 then
        攻击加成=0.677+(self.熟练度-10000)*0.00114/100
    elseif self.熟练度>=5000 then
        攻击加成=0.596+(self.熟练度-5000)*0.00162/100
    else
        攻击加成=0.3+self.熟练度*0.00592/100
    end
    效果.攻击 = math.floor( 挨打方.攻击 * ( 攻击加成 * ( 1 + 攻击方.加强加攻法术 * 0.01 ) ) )
    挨打方.攻击 = 挨打方.攻击 + 效果.攻击
    挨打方.命中率 = 挨打方.命中率 + 效果.命中率
    return 效果
end

function 法术:法术取回合()
    if self.熟练度 >= 18000 then
        return 8
    elseif self.熟练度 >= 12000 then
        return 7
    elseif self.熟练度 >= 6800 then
        return 6
    elseif self.熟练度 >= 3000 then
        return 5
    elseif self.熟练度 >= 1200 then
        return 4
    else
        return 3
    end
end

function 法术:取目标数()
    if self.熟练度 >= 11826 then
        return 7
    elseif self.熟练度 >= 4533 then
        return 6
    elseif self.熟练度 >= 1174 then
        return 5
    elseif self.熟练度 >= 117 then
        return 4
    else
        return 3
    end
end

function 法术:法术取目标数()
    return self:取目标数(), function(a, b)
        return a.攻击 > b.攻击
    end
end

function 法术:法术取消耗()
    return { 消耗MP = math.floor(self.熟练度 * 0.318) }
end

function 法术:取AP()
    local n = math.floor((0.35 + 0.016 * self.熟练度 ^ 0.3317) * 100) * 0.01
    return n
end

function 法术:法术取描述()
    local 攻击加成=0
    if self.熟练度>=25000 then
        攻击加成=0.819+(self.熟练度-25000)*0.00062/100
    elseif self.熟练度>=20000 then
        攻击加成=0.78+(self.熟练度-20000)*0.00078/100
    elseif self.熟练度>=15000 then
        攻击加成=0.734+(self.熟练度-15000)*0.00092/100
    elseif self.熟练度>=10000 then
        攻击加成=0.677+(self.熟练度-10000)*0.00114/100
    elseif self.熟练度>=5000 then
        攻击加成=0.596+(self.熟练度-5000)*0.00162/100
    else
        攻击加成=0.3+self.熟练度*0.00592/100
    end
    攻击加成=攻击加成*100
    return string.format('增加AP#R%s#G，命中15%%，使用效果#R%s#G人，持续效果#R%s#G个回合。', 攻击加成.. "%", self:取目标数(), self:法术取回合())
end

BUFF = {
    法术 = '魔神附身',
    名称 = '攻',
    id = 1005
}


法术.BUFF = BUFF
function BUFF:BUFF回合结束(单位)
    if self.回合数 >= self.回合 then
        self:删除()
        单位.攻击 = 单位.攻击 - self.效果.攻击
        单位.命中率 = 单位.命中率 - self.效果.命中率
    end
end

return 法术
