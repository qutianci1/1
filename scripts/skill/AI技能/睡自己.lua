-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-07 18:25:21
-- @Last Modified time  : 2023-09-03 15:50:51
local 法术 = {
    类别 = '门派',
    类型 = 1,
    对象 = 1,
    条件 = 37,
    名称 = '睡自己',
    id = 204
}

local BUFF
function 法术:法术施放(攻击方, 目标)
    local 消耗mp = 0
    self.xh = 消耗mp
    for _, v in ipairs(目标) do
        v:被使用法术(攻击方, self)
        local b = v:添加BUFF(BUFF)
        if b then
            b.回合 = 3
            b.挣脱率 = 0
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
end

function 法术:法术取回合()
end

function 法术:取目标数()
    return 1
end

function 法术:法术取目标数()
    return 1
end

function 法术:法术取消耗()
end

function 法术:法术取描述()
    return '昏睡目标3回合'
end

BUFF = {
    法术 = '睡自己',
    名称 = '睡',
    id = 201
}
法术.BUFF = BUFF

function BUFF:BUFF回合开始() --挣脱
end

function BUFF:BUFF指令开始(目标) --昏睡
    if 目标.指令 == '道具' or 目标.指令 == '召唤' or 目标.指令 == '招还' then
        return true
    end
    return false
end

function BUFF:BUFF被物理攻击后(a,目标)
    目标.昏睡解除 = true
    self:删除()
end

function BUFF:BUFF被法术攻击后(a,目标)
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
