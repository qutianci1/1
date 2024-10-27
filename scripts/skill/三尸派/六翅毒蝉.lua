-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-06 19:05:22
-- @Last Modified time  : 2023-08-23 02:40:38

local 法术 = {
    类别 = '门派',
    类型 = 1,
    对象 = 2,
    条件 = 37,
    名称 = '六翅毒蝉',
    id = 1902,
}

function 法术:法术施放(攻击方, 目标)
    local 消耗mp = self:法术取消耗().消耗MP
    if 攻击方.魔法 < 消耗mp then
        攻击方:提示("#R魔法不足，无法释放！")
        return false
    end
    self.xh = 消耗mp
    self.吸血值 = {}
    for i, v in ipairs(目标) do
        攻击方.伤害 = self:法术取伤害(攻击方, v)
        self.吸血值[i]=攻击方.伤害
        v:被法术攻击(攻击方, self)
    end
end

function 法术:法术施放后(攻击方, 目标)
    if self.xh then
        攻击方:减少魔法(self.xh)
        self.xh=false
        local list = {}
        local px = {}
        for _, v in 攻击方:遍历我方() do
            if v.是否玩家 and v.是否死亡 and not v:取BUFF('封印') then
                table.insert(list, v)
            elseif not v:取BUFF('封印') then
                table.insert(list, v)
            end
        end

        table.sort(list, function(a, b)
            if a.是否死亡 and not b.是否死亡 then
                return true
            elseif not a.是否死亡 and b.是否死亡 then
                return false
            else
                local aa = a.气血 / a.最大气血
                local bb = b.气血 / b.最大气血
                return aa < bb
            end
        end)
        for i, v in ipairs(目标) do
            if list[i] then
                if self.吸血值[i] then
                    local 回复=math.floor(self.吸血值[i]*(2.8+攻击方.加强三尸虫回血程度 * 0.01))
                    list[i]:增加气血(回复)
                end
            end
        end
    end
end

function 法术:法术取伤害(攻击方, 挨打方)
    local 伤害 = 0
    local 等级 = 攻击方.等级 + 1
    local 狂暴系数=1
    伤害=等级*35+self.熟练度*0.18+攻击方.加强三尸虫
    if math.random(100) < 攻击方.三尸虫狂暴几率 then
        狂暴系数=1.5+攻击方.三尸虫狂暴程度*0.01
        挨打方.伤害类型 = "狂暴"
    end
    local 攻击五行,挨打五行=取五行属性(攻击方),取五行属性(挨打方)
    local 攻击方五行克制=取五行强克(攻击方)
    伤害=(伤害-挨打方.抗性.抗三尸虫)*狂暴系数*(1+0.5*取五行克制(攻击五行,挨打五行))*取强力克系数(攻击方五行克制,挨打五行)*取无属性伤害加成(攻击方,挨打方)
    if 伤害 <= 0 then
        伤害 = 1
    end
    return math.floor(伤害)
end

function 法术:法术取目标数()
    return 1
end

function 法术:法术取消耗()
    return { 消耗MP = math.floor(self.熟练度 * 0.123) }
end

function 法术:法术取描述()
    return string.format('利三尸派独门培育的蛊虫，每500年生翅一对，可用来吸血练功。可将伤害的一定百分比化为己方所用，目标人数1人。')
end

return 法术
