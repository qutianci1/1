-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-06 19:05:22
-- @Last Modified time  : 2024-02-15 21:59:35

local 法术 = {
    类别 = '门派',
    类型 = 1,
    对象 = 2,
    条件 = 37,
    名称 = '龙腾水溅',
    id = 802,
    是否仙法 = true
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
    local 伤害 = 0
    local 等级 = 攻击方.等级 + 1
    local 狂暴系数=1
    local 攻击五行,挨打五行=取五行属性(攻击方),取五行属性(挨打方)
    local 攻击方五行克制=取五行强克(攻击方)

    伤害 = 等级 * (49.994 + 1.44271 * math.pow(self.熟练度 , 0.4))
    if math.random(100) < 攻击方.水系狂暴几率 - 挨打方.抗水法狂暴率 then
        狂暴系数=1.5+攻击方.水系狂暴程度 * 0.01
        挨打方.伤害类型 = "狂暴"
    end

    local 无视抗性 = 0
    if 攻击方.开天辟地 then
        if 攻击方.开天辟地 >= math.random(100) then
            无视抗性 = 挨打方.抗水/100
        end
    end
    伤害=伤害*(1+攻击方.加强水/100)*(1+攻击方.忽视抗水/100+无视抗性-挨打方.抗性.抗水/100)*狂暴系数*(1+0.5*取五行克制(攻击五行,挨打五行))*取强力克系数(攻击方五行克制,挨打五行)*取无属性伤害加成(攻击方,挨打方)
    if 挨打方.孩子增益.玄冰甲 or 挨打方.孩子增益.水系吸收 then
        local 护盾总值 = 挨打方.孩子增益.玄冰甲 + 挨打方.孩子增益.水系吸收
        if 护盾总值 >= 伤害 then
            if 挨打方.孩子增益.玄冰甲 >= 伤害 then
                挨打方.孩子增益.玄冰甲 = 挨打方.孩子增益.玄冰甲 - 伤害
            else
                挨打方.孩子增益.水系吸收 = 挨打方.孩子增益.水系吸收 - (伤害 - 挨打方.孩子增益.玄冰甲)
                挨打方.孩子增益.玄冰甲 = 0
            end
            伤害 = 0
        else
            伤害 = 伤害 - 护盾总值
            挨打方.孩子增益.水系吸收 = 0
            挨打方.孩子增益.玄冰甲 = 0
        end
    end
    if 伤害 <= 0 then
        伤害 = 1
    end
    return math.floor(伤害)
end

function 法术:法术取目标数()
    return 1
end

function 法术:法术取消耗()
    return { 消耗MP = math.floor(self.熟练度 * 0.123) }
end

function 法术:法术取描述()
    return string.format('用龙召唤水攻击敌人#R%s#G人。',
        self:法术取目标数())
end

return 法术
