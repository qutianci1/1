-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-06 19:05:22
-- @Last Modified time  : 2024-02-16 04:53:03

local 法术 = {
    类别 = '门派',
    类型 = 1,
    对象 = 2,
    条件 = 37,
    名称 = '鹤顶红粉',
    id = 104,
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
        local n = self:法术取伤害(攻击方, v)
        攻击方.伤害 = n
        v:被法术攻击(攻击方, self)
        local 几率=self:取是否中毒(攻击方, v)
        if math.random(100) <几率  then
            local b = v:添加BUFF(BUFF)
            if b then
                b.回合 = self:法术取回合()
                b.毒伤害 = n
                b.挣脱率 = 100 - 几率
            end
        end
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
    local 等级 = 攻击方.等级
    local 攻击五行,挨打五行=取五行属性(攻击方),取五行属性(挨打方)
    local 攻击方五行克制=取五行强克(攻击方)

    伤害=等级/100*(((self.熟练度^0.4)-(self.熟练度^0.005-1))*185.276)+(等级*60-1)
    伤害=(攻击方.加强毒伤害 / 100 *1.15+1)*(((1+取五行克制(攻击五行,挨打五行)*0.5)*(取强力克系数(攻击方五行克制,挨打五行)*0.5*0.4+1)-1)*0.7+1)*伤害*0.8*取无属性伤害加成(攻击方,挨打方)-挨打方.抗毒伤害
    return math.floor(伤害)
end

function 法术:法术取回合()
    if self.熟练度 >= 12000 then
        return 7
    elseif self.熟练度 >= 9600 then
        return 6
    elseif self.熟练度 >= 5800 then
        return 5
    elseif self.熟练度 >= 2300 then
        return 4
    else
        return 3
    end
end

function 法术:取是否中毒(攻击方, 挨打方)
    local 基础命中率=95
    基础命中率=(基础命中率+攻击方.忽视抗毒-挨打方.抗中毒)*(1+攻击方.加强毒/100)
    return 基础命中率
end

function 法术:法术取目标数()
    return 1
end

function 法术:法术取消耗()
    return { 消耗MP = math.floor(self.熟练度 * 0.198) }
end

function 法术:法术取描述()
    return string.format('给对手#R%s#G人造成#R%s#G个回合中毒伤害。',
        self:法术取目标数(), self:法术取回合())
end

BUFF = {
    法术 = '鹤顶红粉',
    名称 = '中毒',
    id = 101
}
法术.BUFF = BUFF
function BUFF:BUFF添加后(buff, 目标)
    if self == buff then
    end
end

function BUFF:BUFF回合开始(目标)
    if math.random(100) < self.挣脱率 then
        self:删除()
    else
        目标:减少气血(self.毒伤害)
        self.毒伤害 = math.floor(self.毒伤害 * 0.75)
    end
end

function BUFF:BUFF回合结束()
    if self.回合数 >= self.回合 then
        self:删除()
    end
end

function BUFF:孩子解除()
    self:删除()
end

return 法术
