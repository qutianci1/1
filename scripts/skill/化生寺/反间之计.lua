-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-07 18:25:21
-- @Last Modified time  : 2023-09-30 21:45:43
local 法术 = {
    类别 = '门派',
    类型 = 1,
    对象 = 2,
    条件 = 37,
    名称 = '反间之计',
    id = 301
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
    local 基础命中率=56+3.6*(self.熟练度^0.3)
    local 命中率=(基础命中率+攻击方.忽视抗混-挨打方.抗混乱)*(1+(攻击方.加强混乱/100))
    return 命中率
end

function 法术:法术取回合()
    if self.熟练度 >= 11000 then
        return 4
    elseif self.熟练度 >= 1200 then
        return 3
    else
        return 2
    end
end

function 法术:取目标数()
    return 1
end

function 法术:法术取目标数()
    return self:取目标数(), function(a, b)
        return a.速度 > b.速度
    end
end

function 法术:法术取消耗()
    return { 消耗MP = math.floor(self.熟练度 * 0.117) }
end

function 法术:法术取描述()
    return string.format('使对方#R%s#G人混乱#R%s#G个回合并且随机攻击战场中的任何人。',
        self:取目标数(), self:法术取回合())
end

BUFF = {
    法术 = '反间之计',
    名称 = '混乱',
    id = 301
}
法术.BUFF = BUFF
function BUFF:BUFF添加后(buff, 目标)
    if self == buff then
        目标:删除BUFF('昏睡')
        目标:删除BUFF('遗忘')
    end
end

function BUFF:BUFF回合开始() --挣脱
    if math.random(100) < self.挣脱率 then
        self:删除()
    end
end

function BUFF:BUFF指令开始(目标) --混乱
    local r
    if math.random(100) > 50 then
        r = 目标:随机我方存活目标()
        if not r then
            r = 目标:随机敌方存活目标()
        end
    else
        r = 目标:随机敌方存活目标()
        if r == 0 then
            r = 目标:随机我方存活目标()
        end
    end
    目标:置指令('物理', r)
end

function BUFF:BUFF回合结束()
    if self.回合数 >= self.回合 then
        self:删除()
    end
end

function BUFF:BUFF队友伤害(来源)
    return true
end

function BUFF:宝莲灯解除()
    self:删除()
end
return 法术
