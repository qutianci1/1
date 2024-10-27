-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-07 18:25:22
-- @Last Modified time  : 2023-09-03 14:26:28
local 法术 = {
    类别 = '门派',
    类型 = 1,
    对象 = 1,
    条件 = 37,
    名称 = '急速之魔',
    id = 1102
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
    local 效果 = { 速度 = 0 }
    local 速度加成=0
    if self.熟练度>=25000 then
        速度加成=0.166
    elseif self.熟练度>=20000 then
        速度加成=0.159+(self.熟练度-20000)*0.00014/100
    elseif self.熟练度>=15000 then
        速度加成=0.151+(self.熟练度-15000)*0.00016/100
    elseif self.熟练度>=10000 then
        速度加成=0.14+(self.熟练度-10000)*0.00022/100
    elseif self.熟练度>=5000 then
        速度加成=0.124+(self.熟练度-5000)*0.00032/100
    else
        速度加成=0.05+self.熟练度*0.00148/100
    end
    效果.速度 = math.floor(挨打方.速度 * (速度加成 * (1 + 攻击方.加强加速法术 * 0.01)))
    挨打方.速度 = 挨打方.速度 + 效果.速度
    return 效果
end

function 法术:法术取回合()
    if self.熟练度 >= 23000 then
        return 11
    elseif self.熟练度 >= 18000 then
        return 10
    elseif self.熟练度 >= 15000 then
        return 9
    elseif self.熟练度 >= 10000 then
        return 8
    elseif self.熟练度 >= 5000 then
        return 7
    elseif self.熟练度 >= 2000 then
        return 6
    elseif self.熟练度 >= 700 then
        return 5
    elseif self.熟练度 >= 80 then
        return 4
    else
        return 3
    end
end

function 法术:法术取目标数()
    return 1
end

function 法术:法术取消耗()
    return { 消耗MP = math.floor(self.熟练度 * 0.143) }
end

function 法术:法术取描述()
    local 速度加成=0
    if self.熟练度>=25000 then
        速度加成=0.166
    elseif self.熟练度>=20000 then
        速度加成=0.159+(self.熟练度-20000)*0.00014/100
    elseif self.熟练度>=15000 then
        速度加成=0.151+(self.熟练度-15000)*0.00016/100
    elseif self.熟练度>=10000 then
        速度加成=0.14+(self.熟练度-10000)*0.00022/100
    elseif self.熟练度>=5000 then
        速度加成=0.124+(self.熟练度-5000)*0.00032/100
    else
        速度加成=0.05+self.熟练度*0.00148/100
    end
    速度加成=速度加成*100
    return string.format('增加#RSP%s#G，使用效果1人，持续效果#R%s#G个回合。', 速度加成..'%',self:法术取回合())
end

BUFF = {
    法术 = '急速之魔',
    名称 = '速',
    id = 1102
}
法术.BUFF = BUFF
function BUFF:BUFF添加后(buff, 目标)
    if buff == self then
        目标.战场.重新排序 = true
    end
end

function BUFF:BUFF回合结束(单位)
    if self.回合数 >= self.回合 then
        self:删除()
        单位.速度 = 单位.速度 - self.效果.速度
    end
end

return 法术
