-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-07 18:25:22
-- @Last Modified time  : 2023-04-25 21:47:32
local 法术 = {
    类别 = '门派',
    类型 = 1,
    对象 = 2,
    条件 = 37,
    名称 = '麻沸散',
    id = 2001
}

local BUFF
function 法术:法术施放(攻击方, 目标)
    local 消耗mp = self:法术取消耗().消耗MP
    if 攻击方.魔法 < 消耗mp then
        攻击方:提示("#R魔法不足，无法释放！")
        return false
    end
    self.xh = 消耗mp
    for i, v in ipairs(目标) do
        v:被使用法术(攻击方, self)
        local 几率 = self:法术取几率(攻击方, v)--这里的几率是遗忘命中几率,不是技能遗忘几率
        if math.random(100) < 几率 then
            local b = v:添加BUFF(BUFF)
            if b then
                b.回合 = self:法术取回合()
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

function 法术:法术取几率(攻击方, 挨打方)
    local 基础命中率=56+3.6*(self.熟练度^0.3)
    local 命中率=(基础命中率+攻击方.忽视抗遗忘-挨打方.抗遗忘)*(1+攻击方.加强遗忘)
    return 命中率
end

function 法术:法术取回合()
    if self.熟练度 >= 5800 then
        return 4
    elseif self.熟练度 >= 2300 then
        return 3
    else
        return 2
    end
end

function 法术:法术取消耗()
    return { 消耗MP = math.floor(self.熟练度 * 0.113) }
end

function 法术:法术取目标数()
    return 1
end

function 法术:法术取描述()
    return string.format('使对手陷入半麻醉状态,神志不清。每个技能都有40%%几率被遗忘,无法使用物品，目标人数1人，持续#R%s#G个回合。'
        , self:法术取回合())
end

BUFF = {
    法术 = '麻沸散',
    名称 = '遗忘',
    id = 1701
}
法术.BUFF = BUFF
function BUFF:BUFF回合开始(单位) --挣脱
    if math.random(100) < self.挣脱率 then
        self:删除()
    end
end

function BUFF:BUFF法术施放前(src)
    local 法术 = src.当前法术
    return not self.遗忘[法术.名称]
end

function BUFF:BUFF物品使用前(src)
    return false
end

function BUFF:BUFF添加后(buff, 目标)
    if buff == self then
        self.遗忘 = {}
        for k, v in 目标:遍历法术() do
            if math.random(100) <= 40 then
                self.遗忘[v.名称] = true
            end
        end
        目标:删除BUFF('混乱')
        目标:删除BUFF('昏睡')
    end
end

function BUFF:BUFF回合结束()
    if self.回合数 >= self.回合 then
        self:删除()
    end
end

return 法术
