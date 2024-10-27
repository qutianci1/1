-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-06 19:05:22
-- @Last Modified time  : 2023-09-16 00:24:36

local 法术 = {
    类别 = '门派',
    类型 = 1,
    对象 = 2,
    条件 = 37,
    名称 = '金箍儿',
    id = 1500
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
                b.挣脱率 = 0
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
    if self.熟练度 >= 0 and self.熟练度 <= 100 then
        return 21.6 + (self.熟练度 - 0) * ((61.4 - 21.6) / (100 - 0))
    elseif self.熟练度 >= 101 and self.熟练度 <= 200 then
        return 61.4 + (self.熟练度 - 101) * ((89.5 - 61.4) / (200 - 101))
    else
        return 0
    end
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
    return string.format('使对手#R%s#W个回合内,无法使用法宝以外的其他法术,成功率#R%s%%',
        self:法术取回合(), math.floor(self:法术取几率() * 100)/100)
end

BUFF = {
    法术 = '金箍儿',
    名称 = '金箍儿',
    id = 1511
}
法术.BUFF = BUFF
function BUFF:BUFF回合开始()
    if math.random(100) < self.挣脱率 then
        self:删除()
    end
end

function BUFF:BUFF指令开始(目标)
    if 目标.指令 == '法术' then
        local 法术名称 = 目标:取技能名称(目标.选择)
        if 法术名称 then
            local 法宝技能 = {"银索金铃","将军令","大势锤","七宝玲珑塔","黑龙珠","幽冥鬼手","大手印","绝情鞭","情网","宝莲灯","金箍儿","番天印","锦襕袈裟","白骨爪","化蝶"}
            local is法宝技能 = false
            for i=1,#法宝技能 do
                if 法宝技能[i] == 法术名称 then
                    is法宝技能 = true
                end
            end
            if is法宝技能 then
                return true
            else
                print('被阻止了')
                return false
            end
        end
    end
    return true
end

function BUFF:BUFF被物理攻击后(a,目标)
end

function BUFF:BUFF被法术攻击后(a,目标)
end

function BUFF:BUFF添加后(buff, 目标)
end

function BUFF:BUFF回合结束()
    if self.回合数 >= self.回合 then
        self:删除()
    end
end

return 法术
