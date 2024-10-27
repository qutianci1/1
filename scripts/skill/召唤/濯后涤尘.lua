-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-06 19:05:22
-- @Last Modified time  : 2023-05-09 08:58:04

local 法术 = {
    类别 = '门派', --技能必须写门派
    类型 = 1, --主动技能
    对象 = 2, --敌方可用
    条件 = 37, --
    名称 = '濯后涤尘',
    id = 136
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
        local b = v:添加BUFF(BUFF)
        b.回合 = 2
        b.效果 = self:法术取BUFF效果(攻击方, v)
    end
end


function 法术:法术施放后(攻击方, 目标)
    if self.xh then
        攻击方:减少魔法(self.xh)
        self.xh=false
    end
end

function 法术:法术取BUFF效果(攻击方, 挨打方)
    local 效果 = { 抗震慑 = 10, 抗遗忘 = 6, 抗鬼火 = 15, 抗三尸虫 = 500 }
    for k, v in pairs(效果) do
        挨打方[k] = 挨打方[k] - v
    end
    return 效果
end

function 法术:法术取描述()
    return '降低目标#R10%#W抗震慑,#R6%#W抗遗忘,#R15%#W抗鬼火,#R500#W抗三尸虫,使用效果为#R1#W人,持续#R2#W回合'
end

function 法术:法术取目标数()
    return 1
end

function 法术:法术取消耗()
    return { 消耗MP = 1000 }
end

BUFF = {
    法术 = '濯后涤尘',
    名称 = '果子减抗',
    id = 1182
}
法术.BUFF = BUFF

function BUFF:BUFF回合结束(单位)
    if self.回合数 >= self.回合 then
        for k, v in pairs(self.效果) do
            单位[k] = 单位[k] + v
        end
        self:删除()
    end
end
return 法术
