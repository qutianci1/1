-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-06 19:05:22
-- @Last Modified time  : 2023-09-18 11:00:49

local 法术 = {
    类别 = '门派',
    类型 = 1,
    对象 = 1,
    条件 = 37,
    名称 = '幽冥鬼手',
    id = 1506
}

local BUFF

function 法术:法术施放(攻击方, 目标)
    local 消耗 = self:法术取消耗()
    if 攻击方.魔法 < 消耗.消耗MP then
        攻击方:提示("#R魔法不足，无法释放！")
        return false
    end
    if 攻击方.怨气 < 消耗.消耗怨气 then
        攻击方:提示("#R怨气不足，无法释放！")
        return false
    end
    self.xh = 消耗
    for _, v in ipairs(目标) do
        v:被使用法术(攻击方, self)
        local b = v:添加BUFF(BUFF)
        if b then
            b.回合 = self:法术取回合()
            v.幽冥鬼手 = self:法术取比例(攻击方, 挨打方)
        end
    end
end

function 法术:法术施放后(攻击方, 目标)
    if self.xh then
        攻击方:减少魔法(self.xh.消耗MP)
        攻击方:减少怨气(self.xh.消耗怨气)
        self.xh=false
    end
end

function 法术:法术取比例(攻击方, 挨打方)
    local ratio = 23.5
    ratio = ratio + (self.熟练度 - 1) * (166.6 - ratio) / (200 - 1)
    return ratio
end

function 法术:法术取回合()
    local rounds = 2
    if self.熟练度 >= 20 then
        rounds = rounds + 1
    end
    if self.熟练度 >= 60 then
        rounds = rounds + 1
    end
    if self.熟练度 >= 80 then
        rounds = rounds + 1
    end
    if self.熟练度 >= 112 then
        rounds = rounds + 1
    end
    if self.熟练度 >= 156 then
        rounds = rounds + 1
    end
    if self.熟练度 >= 200 then
        rounds = rounds + 1
    end
    return rounds
end

function 法术:法术取消耗()
    return { 消耗MP = math.floor(self.熟练度 * 50 + 1030), 消耗怨气 = math.floor(self.熟练度 * 1 + 151) }
end

function 法术:取目标数()
    return 1
end

function 法术:法术取目标数()
    return self:取目标数(), function(a, b)
        return a.速度 > b.速度
    end
end

function 法术:法术取描述()
    return string.format('在#R%s#W回合内物理攻击用内力震荡其他对手造成#R%s%%#W的隔山打牛伤害。',
        self:法术取回合(), math.floor(self:法术取比例() * 100)/100)
end

BUFF = {
    法术 = '幽冥鬼手',
    名称 = '幽冥鬼手',
    id = 1506
}
法术.BUFF = BUFF
function BUFF:BUFF添加后(buff, 目标)
end

function BUFF:BUFF回合结束(单位)
    if self.回合数 >= self.回合 then
        self:删除()
        单位.七宝玲珑塔 = nil
    end
end

return 法术
