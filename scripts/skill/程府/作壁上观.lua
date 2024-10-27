-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-06 19:05:22
-- @Last Modified time  : 2023-09-18 11:17:37

local 法术 = {
    类别 = '门派',
    类型 = 1,
    对象 = 2,
    条件 = 37,
    名称 = '作壁上观',
    id = 404,
    程府=true
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
    local 基础命中率=80+3.6*(self.熟练度^0.3)
    local 命中率=(基础命中率+攻击方.忽视抗封-挨打方.抗封印)*(1+攻击方.加强封印)
    return 命中率
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

function 法术:法术取消耗()
    return { 消耗MP = math.floor(self.熟练度 * 0.198) }
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
    return string.format('用冰冻封印的方式让对手#R%s#G人#R%s#G个回合无法进行攻击但是其他人也无法伤害他。'
        , self:取目标数(), self:法术取回合())
end

BUFF = {
    法术 = '作壁上观',
    名称 = '封印',
    id = 401
}
法术.BUFF = BUFF

function BUFF:BUFF回合开始(单位) --挣脱
    if math.random(100) < self.挣脱率 then
        self:删除()

    end
    --目标:取法术("脱困术")
end

function BUFF:BUFF指令开始()
    return false
end

function BUFF:BUFF被物理攻击前()
    return false
end

function BUFF:BUFF被法术攻击前()
    return false
end

function BUFF:BUFF添加前(buff, 目标)
    if buff.名称 ~= "封印" then
        return false
    end
end

function BUFF:BUFF添加后(buff, 目标)
    if self == buff then
        目标:删除BUFF('混乱')
        目标:删除BUFF('昏睡')
        目标:删除BUFF('中毒')
        目标:删除BUFF('遗忘')
    end
end

function BUFF:BUFF回合结束(单位)
    if self.回合数 >= self.回合 then
        self:删除()
    end
end

function BUFF:大手印解除()
    self:删除()
end

return 法术
