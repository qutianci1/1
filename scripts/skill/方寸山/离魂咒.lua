-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-06 19:05:22
-- @Last Modified time  : 2024-02-16 21:27:54

local 法术 = {
    类别 = '门派',
    类型 = 1,
    对象 = 2,
    条件 = 37,
    名称 = '离魂咒',
    id = 203,
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
        local 几率 = self:法术取几率(攻击方, v)
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
    local 基础命中率=71+3.6*(self.熟练度^0.3)
    local 命中率=(基础命中率+攻击方.忽视抗睡-挨打方.抗昏睡)*(1+攻击方.加强昏睡)
    return 命中率
end

function 法术:法术取回合()
    if self.熟练度 >= 9600 then
        return 5
    elseif self.熟练度 >= 5800 then
        return 4
    elseif self.熟练度 >= 2300 then
        return 3
    else
        return 2
    end
end

function 法术:法术取消耗()
    return { 消耗MP = math.floor(self.熟练度 * 0.178) }
end

function 法术:取目标数()
    if self.熟练度 >= 9866 then
        return 5
    elseif self.熟练度 >= 3098 then
        return 4
    elseif self.熟练度 >= 428 then
        return 3
    else
        return 2
    end
end

function 法术:法术取目标数(r)
    local a = 0
    r = r or {}
    if r.摇篮曲 or r.昏睡术 then
        a = 1
    end
    local 目标数 = self:取目标数() + a
    return 目标数, function(a, b)
        return a.速度 > b.速度
    end
end

function 法术:法术取描述()
    return string.format('可以造成对手#R%s#G人昏睡无法行动#R%s#G个回合。',
        self:取目标数(), self:法术取回合())
end

BUFF = {
    法术 = '离魂咒',
    名称 = '昏睡',
    id = 201
}
法术.BUFF = BUFF
function BUFF:BUFF回合开始() --挣脱
    if math.random(100) < self.挣脱率 then
        self:删除()
    end
end

function BUFF:BUFF指令开始(目标) --昏睡
    if 目标.指令 == '道具' or 目标.指令 == '召唤' or 目标.指令 == '招还' then
        return true
    end
    return false
end

function BUFF:BUFF被物理攻击后(a,目标)
    if 目标.是否怪物 then
        if 目标.名称 == '贪睡的小蛇' then
            目标.狂暴状态 = true
        end
    end
    目标.昏睡解除 = true
    self:删除()
end

function BUFF:BUFF被法术攻击后(a,目标)
    if 目标.是否怪物 then
        if 目标.名称 == '贪睡的小蛇' then
            目标.狂暴状态 = true
        end
    end
    目标.昏睡解除 = true
    self:删除()
end

function BUFF:BUFF添加后(buff, 目标)
    if self == buff then
        目标:删除BUFF('混乱')
        目标:删除BUFF('遗忘')
    end
end

function BUFF:BUFF回合结束()
    if self.回合数 >= self.回合 then
        self:删除()
    end
end

return 法术
