-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-06 19:05:22
-- @Last Modified time  : 2023-09-18 18:21:11

local 法术 = {
    类别 = '门派',
    类型 = 1,
    对象 = 1,
    条件 = 37,
    名称 = '化蝶',
    id = 1517
}

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
        if 攻击方.转生 < v.转生 then
            攻击方:提示("你不能对这个目标是用化蝶")
            return false
        end
        if 攻击方.等级 < v.等级 - 30 then
            攻击方:提示("你不能对这个目标是用化蝶")
            return false
        end
        if 攻击方.气血 < 攻击方.最大气血 * 0.3 then
            攻击方:提示("你的气血值过低,无法使用化蝶")
            return false
        end
        local 比例 = self:法术取比例(攻击方, 挨打方)
        local 几率 = 1000--self:法术成功率(攻击方, v) * 10
        if math.random(1000) <= 几率 then
            攻击方.伤害 = math.floor(攻击方.气血 * (比例 / 100))
            v:被法术攻击(攻击方, self)
        end
    end
end

function 法术:法术施放后(攻击方, 目标)
    if self.xh then
        攻击方:减少魔法(self.xh.消耗MP)
        攻击方:减少怨气(self.xh.消耗怨气)
        攻击方:减少气血(攻击方.气血 - 1)
        self.xh=false
    end
end

function 法术:法术成功率(攻击方, 挨打方)
    local ratio = 23.5
    ratio = ratio + (self.熟练度 - 1) * (143.1 - ratio) / (200 - 1)
    return ratio
end

function 法术:法术取比例(攻击方, 挨打方)
    local ratio = 15.7
    ratio = ratio + (self.熟练度 - 1) * (95.3 - ratio) / (200 - 1)
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
    return string.format('有#R%s%%#W的几率对对手造成施法者当前气血#R%s%%#W的伤害,使用后施法者的当前气血变成1点。',
        math.floor(self:法术成功率() * 100)/100, math.floor(self:法术取比例() * 100)/100)
end

return 法术
