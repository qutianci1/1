-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-06 19:05:22
-- @Last Modified time  : 2024-02-16 04:55:41

local 法术 = {
    类别 = '门派',
    类型 = 1,
    对象 = 2,
    条件 = 37,
    名称 = '阎罗追命',
    id = 1205,
}

function 法术:法术施放(攻击方, 目标)
    local 消耗mp = self:法术取消耗().消耗MP
    if 攻击方.魔法 < 消耗mp then
        攻击方:提示("#R魔法不足，无法释放！")
        return false
    end
    self.xh = 消耗mp
    for _, v in ipairs(目标) do
        攻击方.伤害 = self:法术取伤害(攻击方, v)
        v:被法术攻击(攻击方, self)

    end
end

function 法术:法术施放后(攻击方, 目标)
    if self.xh then
        攻击方:减少魔法(self.xh)
        self.xh=false
    end
end

function 法术:法术取伤害(攻击方, 挨打方)
    local 震慑,扣蓝=0,0
    震慑 = 0.25 + 0.005 * math.pow(self.熟练度 , 0.35)
    扣蓝 = 0.06 + 0.006 * math.pow(self.熟练度 , 0.35)

    local 攻击五行,挨打五行=取五行属性(攻击方),取五行属性(挨打方)
    local 攻击方五行克制=取五行强克(攻击方)
    震慑 = (挨打方.气血 * (震慑 - 挨打方.抗震慑/100 + 攻击方.忽视抗震慑/100) * (1+0.5*取五行克制(攻击五行,挨打五行)) * 取强力克系数(攻击方五行克制,挨打五行) * 取无属性伤害加成(攻击方,挨打方) * (1 + 攻击方.加强震慑 / 100) + 攻击方.等级 * 3) * ( 1 - 挨打方.抗震慑气血/100)
    if 震慑 > 挨打方.最大气血 * 0.5 then
        震慑 = 挨打方.最大气血 * 0.5
    end
    扣蓝 = (挨打方.魔法 * 扣蓝 * (1 + 攻击方.加强震慑/100) + 攻击方.等级 * 3) * ( 1 - 挨打方.抗震慑魔法/100)
    if 挨打方.孩子增益.定心咒 or 挨打方.孩子增益.龙神心法 then
    else
        挨打方:减少魔法(math.floor(扣蓝))
    end
    挨打方:减少魔法(math.floor(扣蓝))
    if 震慑 < 1 then
        震慑 = 1
    end
    return math.floor(震慑)
end

function 法术:法术取目标数(r)
    local a = 0
    r = r or {}
    if r.摄气诀 or r.震慑强化 then
        a = 1
    end
    if self.熟练度 >= 11864 then
        return 7 + a
    elseif self.熟练度 >= 5215 then
        return 6 + a
    elseif self.熟练度 >= 1638 then
        return 5 + a
    elseif self.熟练度 >= 226 then
        return 4 + a
    else
        return 3 + a
    end
end

function 法术:法术取消耗()
    return { 消耗MP = math.floor(self.熟练度 * 0.721) }
end

function 法术:取HP伤害()
    local n = math.floor((0.25 + 0.005 * math.pow(self.熟练度 , 0.35)) * 10000)/100
    return n
end

function 法术:取MP伤害()
    local n = math.floor((0.06 + 0.006 * math.pow(self.熟练度 , 0.35)) * 10000)/100
    return n
end

function 法术:法术取描述()
    return string.format('减少敌人HP当前#R%s#G和MP当前#R%s#G，使用效果为#R%s#G人。', self:取HP伤害().. "%", self:取MP伤害().. "%", self:法术取目标数())
end

return 法术
