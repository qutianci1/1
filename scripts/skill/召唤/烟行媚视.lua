-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-06 19:05:22
-- @Last Modified time  : 2023-05-09 07:33:13

local 法术 = {
    类别 = '门派', --技能必须写门派
    类型 = 1, --主动技能
    对象 = 2, --敌方可用
    条件 = 37, --
    名称 = '烟行媚视',
    id = 117
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
    local 效果 = { 抗雷 = 0, 抗火 = 0, 抗水 = 0, 抗风 = 0, 物理吸收 = 0, 抗昏睡 = 0, 抗中毒 = 0, 抗混乱 = 0, 抗封印 = 0 }
    local 临时法抗,临时人抗=20,8

    效果.抗雷 = 临时法抗
    效果.抗火 = 临时法抗
    效果.抗水 = 临时法抗
    效果.抗风 = 临时法抗
    效果.物理吸收 = 临时法抗
    效果.抗昏睡 = 临时人抗
    效果.抗中毒 = 临时人抗
    效果.抗混乱 = 临时人抗
    效果.抗封印 = 临时人抗
    for k, v in pairs(效果) do
        挨打方.抗性[k] = 挨打方.抗性[k] - v
    end
    return 效果
end

function 法术:法术取描述()
    return '降低目标#R20#W点仙法抗性和#R8#W点人法抗性,使用效果为#R1#W人,持续#R2#W回合'
end

function 法术:法术取目标数()
    return 1
end

function 法术:法术取消耗()
    return { 消耗MP = 1500 }
end

BUFF = {
    法术 = '烟行媚视',
    名称 = '减抗',
    id = 116
}
法术.BUFF = BUFF

function BUFF:BUFF回合结束(单位)
    if self.回合数 >= self.回合 then
        for k, v in pairs(self.效果) do
            单位.抗性[k] = 单位.抗性[k] + v
        end
        self:删除()
    end
end
return 法术
