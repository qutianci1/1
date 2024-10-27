-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-06 19:05:22
-- @Last Modified time  : 2023-09-18 17:51:21

local 法术 = {
    类别 = '门派',
    类型 = 1,
    对象 = 2,
    条件 = 37,
    名称 = '白骨爪',
    id = 1514
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
        local 几率 = self:法术取几率(攻击方, v) * 10
        if math.random(1000) <= 几率 then
            local b = v:添加BUFF(BUFF)
            if b then
                b.回合 = self:法术取回合()
                v.白骨爪 = self:法术取数值()
            end
        end
    end
end
function 法术:法术施放后(攻击方, 目标)
    if self.xh then
        攻击方:减少魔法(self.xh.消耗MP)--增加怨气消耗
        攻击方:减少怨气(self.xh.消耗怨气)
        self.xh=false
    end
end

function 法术:法术取几率(攻击方, 挨打方)
    local ratio = 22
    ratio = ratio + (self.熟练度 - 1) * (158.6 - ratio) / (200 - 1)
    return ratio
end

function 法术:法术取数值(攻击方, 挨打方)
    local ratio = 2330
    ratio = ratio + (self.熟练度 - 1) * (19603 - ratio) / (200 - 1)
    return math.floor(ratio)
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
    return string.format('使对手#R%s#W个回合内,每个回合开始前流失#R%s#W法力,成功率#R%s%%',
        self:法术取回合(), self:法术取数值(), math.floor(self:法术取几率() * 100)/100)
end

BUFF = {
    法术 = '白骨爪',
    名称 = '白骨爪',
    id = 1514
}
法术.BUFF = BUFF
function BUFF:BUFF回合开始(单位)
    if 单位 then
        单位:减少魔法(单位.白骨爪, nil, true)
    end
end

function BUFF:BUFF回合结束(单位)
    if self.回合数 >= self.回合 then
        self:删除()
        if 单位 then
            单位.白骨爪 = nil
        end
    end
end

return 法术
